import 'package:chat/core/interfaces/repositorys/auth_repository.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends IAuthRepository {
  AuthRepository({required super.auth});

  static ChatUser? _currentUser;

  @override
  ChatUser? currentUser() {
    return _currentUser;
  }

  @override
  Future<void> login(String email, String password) async {
    final credential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (credential.user == null) {
      throw Exception('Email ou senha incorretos');
    }
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<void> signup(String email, String password, String name) async {
    final credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user == null) {
      throw Exception('Conta já cadastrada');
    }
  }

  @override
  Stream<ChatUser?> userChanges() {
    final authChanges = auth.authStateChanges();

    return authChanges.map((user) {
      final chatUser = user == null ? null : _userToChatUser(user);
      _currentUser = chatUser;
      return chatUser;
    });
  }

  ChatUser _userToChatUser(User user) {
    //TODO: Verificar de deixo a responsabilidade de conversão na service.
    return ChatUser(
      id: user.uid,
      email: user.email!,
      name: user.displayName != null
          ? user.displayName!
          : user.email!.split('@')[0],
      imageUrl: user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}

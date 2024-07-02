import 'package:chat/core/interfaces/services/auth_service.dart';
import 'package:chat/core/models/chat_user.dart';

class AuthService extends IAuthService {
  AuthService({required super.authRepository});

  @override
  ChatUser? get currentUser => authRepository.currentUser();

  @override
  Future<void> login(String email, String password) async {
    await authRepository.login(email, password);
  }

  @override
  Future<void> logout() async {
    await authRepository.logout();
  }

  @override
  Future<void> signup(String name, String email, String password) async {
    await authRepository.signup(email, password, name);
  }

  @override
  Stream<ChatUser?> get userChanges => authRepository.userChanges();
}

import 'dart:async';
import 'dart:io';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _controller!.add(_currentUser);
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw Exception('Conta já cadastrada');
    }

    credential.user!.updateDisplayName(name);

    _updateUser(ChatUser(id: credential.user!.uid, email: email, name: name));
  }

  @override
  Future<void> login(String email, String password) async {
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) {
      throw Exception('Email ou senha incorretos');
    }
    _updateUser(ChatUser(
      id: credential.user!.uid,
      email: email,
      name: credential.user!.displayName!,
    ));
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _updateUser(ChatUser user) {
    _currentUser = user;
    _controller!.add(user);
  }
}

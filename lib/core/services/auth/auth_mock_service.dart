import 'dart:async';
import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static final _testUser = ChatUser(
    id: '69',
    email: 'email@email.com',
    name: 'user',
    imageURL: 'imageURL',
  );

  static ChatUser? _currentUser = _testUser;
  static final Map<String, ChatUser> _users = {};
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_currentUser);
  });

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    if (_users[email] != null) {
      throw Exception('Já existe uma conta com esse Email');
    }
    final newUser = ChatUser(
      id: _users.length.toString(),
      email: email,
      name: name,
      imageURL: image?.path ?? '',
    );
    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  @override
  Future<void> login(String email, String password) async {
    final ChatUser? user = _users[email];
    if (user == null) {
      throw Exception('Email ou senha incorretas');
    }
    _updateUser(user);
  }

  @override
  Future<void> logout() async {
    _updateUser(null);
  }
}

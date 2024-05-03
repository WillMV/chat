import 'dart:io';

import 'package:flutter/material.dart';

enum AuthMode { sigup, login }

class AuthFormData {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final nicknameController = TextEditingController();
  File? image;

  AuthMode _mode = AuthMode.login;

  bool get isLogin => _mode == AuthMode.login;

  bool get isSigup => _mode == AuthMode.sigup;

  String get name => nameController.text;
  String get email => emailController.text;
  String get password => passwordController.text;

  String? validateName(String? value) {
    final name = value ?? '';
    if (name.isEmpty || name.length < 5) {
      return 'O nome deve ter ao menos 5 caracteres';
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    final email = value ?? '';
    if (email.isEmpty || !email.contains('@')) {
      return 'Email informado não é valido';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty || password.length < 6) {
      return 'A senha deve ter ao menos 6 caracteres';
    } else {
      return null;
    }
  }

  void toogleAuthMode() {
    _mode == AuthMode.login ? _mode = AuthMode.sigup : _mode = AuthMode.login;
  }
}

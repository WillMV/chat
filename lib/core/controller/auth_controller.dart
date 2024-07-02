import 'package:chat/core/interfaces/controllers/auth_controller.dart';
import 'package:chat/core/interfaces/services/auth_service.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class AuthController extends IAuthController with ChangeNotifier {
  late IAuthService _authService;
  AuthController({required super.authRepository}) {
    _authService = AuthService(authRepository: authRepository);
  }

  // TODO: Verificar se esta responsabilidade deve ficar na UserController.
  @override
  ChatUser? get currentUser => _authService.currentUser;

  @override
  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
  }

  @override
  Future<void> logout() async {
    await _authService.logout();
  }

  @override
  Future<void> signup(String name, String email, String password) async {
    // TODO: Validar se já possui nome de usuário
    await _authService.signup(name, email, password);
  }

  @override
  Stream<ChatUser?> get userChanges => _authService.userChanges;
}

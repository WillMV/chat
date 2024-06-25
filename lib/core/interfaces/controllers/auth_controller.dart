import 'package:chat/core/interfaces/controllers/controller.dart';
import 'package:chat/core/interfaces/repositorys/auth_repository.dart';
import 'package:chat/core/models/chat_user.dart';

abstract class IAuthController implements IController {
  final IAuthRepository authRepository;

  IAuthController({required this.authRepository});

  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future<void> signup(String name, String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();
}

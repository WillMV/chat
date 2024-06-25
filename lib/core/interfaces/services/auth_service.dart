import 'package:chat/core/interfaces/repositorys/auth_repository.dart';
import 'package:chat/core/interfaces/services/service.dart';
import 'package:chat/core/models/chat_user.dart';

abstract class IAuthService implements IService {
  final IAuthRepository authRepository;

  IAuthService({required this.authRepository});

  ChatUser? get currentUser;

  Stream<ChatUser?> get userChanges;

  Future<void> signup(String name, String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();
}

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/chat_user.dart';
import 'repository.dart';

abstract class IAuthRepository implements IRepository {
  final FirebaseAuth auth;

  IAuthRepository({required this.auth});

  ChatUser? currentUser();
  Stream<ChatUser?> userChanges();
  Future<void> login(String email, String password);
  Future<void> signup(String email, String password, String name);
  Future<void> logout();
}

import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/services/user/user_firebase_service.dart';

abstract class UserService {
  Stream<List<ChatContact>> getContacts();

  Future<bool> isValidUserName(String name);

  Future<bool> addContact(String name);

  Future<void> updateUser(Map<String, dynamic> data);

  factory UserService() => UserFirebaseService();
}

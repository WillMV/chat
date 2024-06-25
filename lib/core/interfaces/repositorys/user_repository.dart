import 'package:chat/core/interfaces/repositorys/repository.dart';
import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IUserRepository implements IRepository {
  final FirebaseFirestore store;

  IUserRepository({required this.store});

  Stream<List<ChatContact>> getUserContacts();
  Future<ChatUser> getUserByName(String name);
  Future<ChatUser> getUserById(String id);
  Future<void> addUserContact(ChatContact contact);
  Future<void> updateCurrentUser(Map<String, dynamic> data);
  Future<void> saveUser(ChatUser user);
}

import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseService implements UserService {
  final String userCollection = 'users';
  final String chatCollection = 'chats';

  final firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ChatContact>> getContacts() {
    final currentUser = AuthService().currentUser;

    if (currentUser == null) AuthService().logout();

    final snapshot = firestore
        .collection(chatCollection)
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .where('users', arrayContains: currentUser?.id)
        .orderBy('lastMessage', descending: true)
        .snapshots();

    return snapshot.map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Future<bool> isValidUserName(String name) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    return query.docs.isEmpty;
  }

  @override
  Future<void> updateUser(Map<String, dynamic> data) async {
    final currentUser = AuthService().currentUser;

    if (currentUser == null) return;

    firestore.collection(userCollection).doc(currentUser.id).update(data);
  }

  @override
  Future<bool> addContact(String name) async {
    final currentUser = AuthService().currentUser;

    if (currentUser == null) return false;

    final contact = await firestore
        .collection(userCollection)
        .where('name', isEqualTo: name)
        .get();

    if (contact.docs.isEmpty) return false;
    return true;
  }

  static ChatContact _fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> contact,
      SnapshotOptions? options) {
    return ChatContact(
      id: contact.id,
      users: contact['users'],
      messages: contact['messages'],
    );
  }

  static Map<String, dynamic> _toFirestore(
      ChatContact contact, SetOptions? options) {
    return {
      'users': contact.users,
      'messages': contact.messages,
    };
  }
}

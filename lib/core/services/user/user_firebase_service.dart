import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseService implements UserService {
  final String _userCollection = 'users';
  final String _chatCollection = 'chats';

  final firestore = FirebaseFirestore.instance;

  @override
  Stream<List<ChatContact>> getContacts() {
    final currentUser = AuthService().currentUser;

    if (currentUser == null) AuthService().logout();

    final snapshot = firestore
        .collection(_chatCollection)
        .withConverter(
          fromFirestore: _fromFirestoreToChatContact,
          toFirestore: _toFirestore,
        )
        .where('users', arrayContains: currentUser?.id)
        // .orderBy('lastMessage', descending: true)
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

    firestore.collection(_userCollection).doc(currentUser.id).update(data);
  }

  @override
  Future<bool> addContact(String name) async {
    final currentUser = AuthService().currentUser;

    if (currentUser == null) return false;

    final contact = await firestore
        .collection(_userCollection)
        .where('name', isEqualTo: name)
        .get();

    if (contact.docs.isEmpty) return false;

    if (await ifContactExist(contact.docs[0].id)) {
      throw Exception('Contato já existente');
    }

    firestore.collection(_chatCollection).add({
      'name': name,
      'users': [
        currentUser.id,
        contact.docs[0].id,
      ],
      'messages': []
    });

    return true;
  }

  Future<bool> ifContactExist(String contactId) async {
    final currentUser = AuthService().currentUser;
    if (currentUser == null) return false;

    final query = await firestore
        .collection(_chatCollection)
        .where('users', arrayContains: currentUser.id)
        .get();

    if (query.docs.isEmpty) return false;

    for (var doc in query.docs) {
      final data = doc.data();
      final users = data['users'];
      final hasContact = (users[0] == contactId) || (users[1] == contactId);

      if (hasContact) {
        return true;
      }
    }

    return false;
  }

  static ChatContact _fromFirestoreToChatContact(
      DocumentSnapshot<Map<String, dynamic>> contact,
      SnapshotOptions? options) {
    final data = contact.data();
    final users = data?['users'] as List;

    return ChatContact(
      id: contact.id,
      users: users.map((e) => e.toString()).toList(),
    );
  }

  static Map<String, dynamic> _toFirestore(
      ChatContact contact, SetOptions? options) {
    return {
      'users': contact.users,
    };
  }
}

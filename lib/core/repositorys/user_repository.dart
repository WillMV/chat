import 'package:chat/core/interfaces/repositorys/user_repository.dart';
import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:chat/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository extends IUserRepository {
  UserRepository({required super.store});

  @override
  Future<void> addUserContact(ChatContact contact) async {
    await store
        .collection(CHAT_COLLECTION)
        .withConverter(
          fromFirestore: _fromFirestoreToChatContact,
          toFirestore: _fromChatContactToFirestore,
        )
        .add(contact);
  }

  @override
  Stream<List<ChatContact>> getUserContacts() {
    final currentUser =
        AuthRepository(auth: FirebaseAuth.instance).currentUser()!;
    final snaposhot = store
        .collection(CHAT_COLLECTION)
        .withConverter(
          fromFirestore: _fromFirestoreToChatContact,
          toFirestore: _fromChatContactToFirestore,
        )
        .where('users', arrayContains: currentUser.id)
        .snapshots();
    return snaposhot.map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Future<ChatUser?> getUserByName(String name) async {
    final query = await store
        .collection(USER_COLLECTION)
        .withConverter(
            fromFirestore: _fromFirestoreToChatUser,
            toFirestore: _fromChatUserToFirestore)
        .where('name', isEqualTo: name)
        .get();
    final result = query.docs.isEmpty ? null : query.docs[0].data();

    return result;
  }

  @override
  Future<ChatUser> getUserById(String id) async {
    final query = await store
        .collection(USER_COLLECTION)
        .withConverter(
            fromFirestore: _fromFirestoreToChatUser,
            toFirestore: _fromChatUserToFirestore)
        .doc(id)
        .get();
    final data = query.data();
    if (data == null) throw Exception('Usuário não encontrado');
    return data;
  }

  @override
  Future<void> saveUser(ChatUser user) async {
    await store
        .collection(USER_COLLECTION)
        .withConverter(
            fromFirestore: _fromFirestoreToChatUser,
            toFirestore: _fromChatUserToFirestore)
        .add(user);
  }

  @override
  Future<void> updateCurrentUser(Map<String, dynamic> data) async {
    final currentUser =
        AuthRepository(auth: FirebaseAuth.instance).currentUser()!;

    await store.collection(USER_COLLECTION).doc(currentUser.id).update(data);
  }

  ChatContact _fromFirestoreToChatContact(
      //TODO: Verificar de deixo a responsabilidade de conversão pra ChatUser na service.

      DocumentSnapshot<Map<String, dynamic>> contact,
      SnapshotOptions? options) {
    final data = contact.data();
    final users = data!['users'] as List;

    return ChatContact(
      id: contact.id,
      users: users.map((e) => e.toString()).toList(),
    );
  }

  ChatUser _fromFirestoreToChatUser(
      //TODO: Verificar de deixo a responsabilidade de conversão pra ChatUser na service.

      DocumentSnapshot<Map<String, dynamic>> user,
      SnapshotOptions? options) {
    final data = user.data()!;
    return ChatUser(
      id: user.id,
      email: data['email'],
      name: data['name'],
      imageUrl: data['photoUrl'],
    );
  }

  Map<String, dynamic> _fromChatUserToFirestore(
      //TODO: Verificar de deixo a responsabilidade de conversão pra ChatUser na service.

      ChatUser user,
      SetOptions? options) {
    return {'name': user.name, 'email': user.email, 'photoUrl': user.imageUrl};
  }

  Map<String, dynamic> _fromChatContactToFirestore(
      //TODO: Verificar de deixo a responsabilidade de conversão pra ChatUser na service.

      ChatContact contact,
      SetOptions? options) {
    return {
      'users': contact.users,
    };
  }
}

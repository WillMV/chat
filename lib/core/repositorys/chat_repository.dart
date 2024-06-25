import 'package:chat/core/interfaces/repositorys/chat_repository.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository extends IChatRepository {
  ChatRepository({required super.store});

  @override
  Stream<List<ChatMessage>> messagesStream(String chatId) {
    final snapshots = store
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.map((event) => event.docs.map((e) => e.data()).toList());
  }

  @override
  Future<ChatMessage?> save(String chatId, ChatMessage message) async {
    final docRef = await store
        .collection(CHAT_COLLECTION)
        .doc(chatId)
        .collection(MESSAGES_COLLECTION)
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(message);

    final doc = await docRef
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .get();
    return doc.data();
  }

  static Map<String, dynamic> _toFirestore(
      //TODO: Verificar de deixo a responsabilidade de conversão na service.

      ChatMessage msg,
      SetOptions? options) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImage': msg.userImage
    };
  }

  static ChatMessage _fromFirestore(
      //TODO:
      // Verificar de deixo a responsabilidade de conversão na service.

      DocumentSnapshot<Map<String, dynamic>> msg,
      SnapshotOptions? options) {
    return ChatMessage(
      id: msg.id,
      text: msg['text'],
      createdAt: DateTime.parse(msg['createdAt']),
      userId: msg['userId'],
      userName: msg['userName'],
      userImage: msg['userImage'],
    );
  }
}

import 'dart:async';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('/chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    try {
      final msg = ChatMessage(
        id: '',
        text: text,
        createdAt: DateTime.now(),
        userId: user.id,
        userName: user.name,
        userImage: user.imageURL!,
      );

      final store = FirebaseFirestore.instance;

      final docRef = await store
          .collection('/chat')
          .withConverter(
              fromFirestore: _fromFirestore, toFirestore: _toFirestore)
          .add(msg);

      final doc = await docRef
          .withConverter(
              fromFirestore: _fromFirestore, toFirestore: _toFirestore)
          .get();

      return doc.data();
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Map<String, dynamic> _toFirestore(
      ChatMessage msg, SetOptions? options) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImage': msg.userImage
    };
  }

  static ChatMessage _fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> msg, SnapshotOptions? options) {
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

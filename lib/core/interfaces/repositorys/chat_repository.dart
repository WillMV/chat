import 'package:chat/core/interfaces/repositorys/repository.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IChatRepository implements IRepository {
  final FirebaseFirestore store;
  IChatRepository({
    required this.store,
  });

  Stream<List<ChatMessage>> messagesStream(String chatId);
  Future<ChatMessage?> save(String chatId, ChatMessage message);
}

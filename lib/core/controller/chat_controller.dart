import 'package:chat/core/interfaces/controllers/chat_controller.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat_service.dart';
import 'package:flutter/foundation.dart';

class ChatController extends IChatController with ChangeNotifier {
  late ChatService _chatService;
  ChatController({required super.chatRepository}) {
    _chatService = ChatService(chatRepository: chatRepository);
  }

  @override
  Stream<List<ChatMessage>> messagesStream(String chatId) {
    return _chatService.messagesStream(chatId);
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user, String chatId) async {
    final message = await _chatService.save(text, user, chatId);
    return message;
  }
}

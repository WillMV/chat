import 'package:chat/core/interfaces/services/chat_service.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';

class ChatService extends IChatService {
  ChatService({required super.chatRepository});

  @override
  Future<ChatMessage?> save(String text, ChatUser user, String chatId) async {
    final message = await chatRepository.save(
      chatId: chatId,
      text: text,
      userId: user.id,
      userName: user.name,
      userImage: user.imageUrl ?? 'assets/images/avatar.png',
    );

    return message;
  }

  @override
  Stream<List<ChatMessage>> messagesStream(
    String chatId,
  ) {
    return chatRepository.messagesStream(chatId);
  }
}

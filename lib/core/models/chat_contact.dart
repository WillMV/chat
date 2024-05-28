import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';

class ChatContact {
  final String? id;
  final List<String> users;
  final List<ChatMessage> messages;

  ChatContact({
    this.id,
    required this.users,
    required this.messages,
  });
}

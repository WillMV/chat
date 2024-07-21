import 'package:chat/core/interfaces/controllers/controller.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/repositorys/chat_repository.dart';

abstract class IChatController implements IController {
  final ChatRepository chatRepository;

  IChatController({required this.chatRepository});

  Stream<List<ChatMessage>> messagesStream(String chatId);
  Future<ChatMessage?> save(String text, ChatUser user, String chatId);
}

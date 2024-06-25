import 'package:chat/core/interfaces/repositorys/chat_repository.dart';
import 'package:chat/core/interfaces/services/service.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';

abstract class IChatService implements IService {
  final IChatRepository chatRepository;

  IChatService({required this.chatRepository});

  Stream<List<ChatMessage>> messagesStream(String chatId);
  Future<ChatMessage?> save(String text, ChatUser user, String chatId);
}

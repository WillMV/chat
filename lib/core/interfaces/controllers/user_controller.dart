import 'package:chat/core/interfaces/controllers/controller.dart';
import 'package:chat/core/interfaces/repositorys/user_repository.dart';
import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/models/chat_user.dart';

abstract class IUserController implements IController {
  final IUserRepository userRepository;

  IUserController({required this.userRepository});

  Stream<List<ChatContact>> getContacts();

  Future<bool> isValidUserName(String name);

  Future<void> addUserContact(String userName, String contactName);

  Future<ChatUser> getUserById(String id);

  Future<void> updateCurrentUser(Map<String, dynamic> data);
}

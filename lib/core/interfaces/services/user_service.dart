import 'package:chat/core/interfaces/repositorys/user_repository.dart';
import 'package:chat/core/interfaces/services/service.dart';
import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/models/chat_user.dart';

abstract class IUserService implements IService {
  final IUserRepository userRepository;

  IUserService({required this.userRepository});

  Stream<List<ChatContact>> getContacts();

  Future<bool> isValidUserName(String name);

  Future<ChatUser> getUserById(String id);

  Future<bool> addUserContact(String userName, String contactName);

  Future<void> updateCurrentUser(Map<String, dynamic> data);
}

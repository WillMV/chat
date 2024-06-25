import 'package:chat/core/interfaces/services/user_service.dart';
import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/models/chat_user.dart';

class UserService extends IUserService {
  UserService({required super.userRepository});

  @override
  Future<bool> addUserContact(String userName, String contactName) async {
    await userRepository
        .addUserContact(ChatContact(users: [userName, contactName]));
    return true;
  }

  @override
  Stream<List<ChatContact>> getContacts() => userRepository.getUserContacts();

  @override
  Future<bool> isValidUserName(String name) async {
    final user = await userRepository.getUserByName(name);

    if (user.id.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<void> updateCurrentUser(Map<String, dynamic> data) async {
    userRepository.updateCurrentUser(data);
  }

  @override
  Future<ChatUser> getUserById(String id) async {
    return userRepository.getUserById(id);
  }
}

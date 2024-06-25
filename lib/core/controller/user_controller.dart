import 'package:chat/core/interfaces/controllers/user_controller.dart';
import 'package:chat/core/interfaces/services/user_service.dart';
import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/user_service.dart';
import 'package:flutter/foundation.dart';

class UserController extends IUserController with ChangeNotifier {
  late IUserService _userService;

  UserController({required super.userRepository}) {
    _userService = UserService(userRepository: userRepository);
  }

  @override
  Future<void> addUserContact(String userName, String contactName) async {
    await _userService.addUserContact(userName, contactName);
  }

  @override
  Stream<List<ChatContact>> getContacts() => _userService.getContacts();

  @override
  Future<bool> isValidUserName(String name) async {
    final isValid = await _userService.isValidUserName(name);
    return isValid;
  }

  @override
  Future<void> updateCurrentUser(Map<String, dynamic> data) async {
    await _userService.updateCurrentUser(data);
  }

  @override
  Future<ChatUser> getUserById(String id) async {
    final user = _userService.getUserById(id);
    return user;
  }
}

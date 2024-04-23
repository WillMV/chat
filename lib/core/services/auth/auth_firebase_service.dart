import 'dart:async';
import 'dart:io';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;

  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  static ChatUser _toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      email: user.email!,
      name: user.displayName != null
          ? user.displayName!
          : user.email!.split('@')[0],
      imageURL: user.photoURL ?? 'assets/images/avatar.png',
    );
  }

  @override
  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw Exception('Conta já cadastrada');
    }

    final imageUrl =
        await _uploadUserImage(image, '${credential.user!.uid}.jpg');

    credential.user!.updateDisplayName(name);
    credential.user!.updatePhotoURL(imageUrl);
  }

  @override
  Future<void> login(String email, String password) async {
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user == null) {
      throw Exception('Email ou senha incorretos');
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final imageRef =
        FirebaseStorage.instance.ref().child('usersImage').child(imageName);

    await imageRef.putFile(image);

    return await imageRef.getDownloadURL();
  }
}

import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:chat/core/repositorys/notification_repository.dart';
import 'package:chat/core/repositorys/user_repository.dart';
import 'package:chat/view/pages/auth_or_app_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockFirebaseAuth with Mock implements FirebaseAuth {}

class MockFirebaseMessaging with Mock implements FirebaseMessaging {}

class MockFirebaseFirestore with Mock implements FirebaseFirestore {}

class MockFlutterSecureStorage with Mock implements FlutterSecureStorage {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseMessaging mockFirebaseMessaging;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late AuthController authController;
  late NotificationController notificationController;
  late UserController userController;

  setUpAll(() {
    mockFirebaseMessaging = MockFirebaseMessaging();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    userController = UserController(
        userRepository: UserRepository(store: mockFirebaseFirestore));
    authController =
        AuthController(authRepository: AuthRepository(auth: mockFirebaseAuth));
    notificationController = NotificationController(
      notificationRepository: NotificationRepository(
          messaging: mockFirebaseMessaging, storage: mockFlutterSecureStorage),
    );
  });

  testWidgets('auth or app page ...', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => notificationController),
        ChangeNotifierProvider(create: (_) => authController),
        ChangeNotifierProvider(create: (_) => userController),
      ],
      child: const Material(
        child: AuthOrAppPage(),
      ),
    ));
  });
}

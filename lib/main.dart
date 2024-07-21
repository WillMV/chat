import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/chat_controller.dart';
import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:chat/core/repositorys/chat_repository.dart';
import 'package:chat/core/repositorys/notification_repository.dart';
import 'package:chat/core/repositorys/user_repository.dart';
import 'package:chat/view/pages/auth_or_app_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DevicePreview(
    enabled: kDebugMode,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController(
            authRepository: AuthRepository(
              auth: FirebaseAuth.instance,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatController(
            chatRepository: ChatRepository(
              store: FirebaseFirestore.instance,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationController(
            notificationRepository: NotificationRepository(
              messaging: FirebaseMessaging.instance,
              storage: const FlutterSecureStorage(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(
            userRepository: UserRepository(
              store: FirebaseFirestore.instance,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
          useMaterial3: true,
        ),
        home: const AuthOrAppPage(),
      ),
    );
  }
}

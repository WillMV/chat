import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/pages/auth_page.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading.dart';
import 'package:flutter/material.dart';

class AuthOrAppPage extends StatefulWidget {
  const AuthOrAppPage({super.key});

  @override
  State<AuthOrAppPage> createState() => _AuthOrAppPageState();
}

class _AuthOrAppPageState extends State<AuthOrAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChatUser?>(
        stream: AuthService().userChanges,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            return snapshot.hasData ? const ChatPage() : const AuthPage();
          }
        },
      ),
    );
  }
}

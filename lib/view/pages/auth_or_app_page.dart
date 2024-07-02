import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/view/pages/contacts_page.dart';
import 'package:chat/view/pages/auth_page.dart';
import 'package:chat/view/pages/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrAppPage extends StatefulWidget {
  const AuthOrAppPage({super.key});

  @override
  State<AuthOrAppPage> createState() => _AuthOrAppPageState();
}

class _AuthOrAppPageState extends State<AuthOrAppPage> {
  Future<void> _init(BuildContext context) async {
    await Firebase.initializeApp();
    if (context.mounted) {
      await Provider.of<NotificationController>(context, listen: false).init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else {
            return StreamBuilder<ChatUser?>(
              stream: Provider.of<AuthController>(context).userChanges,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                } else {
                  return snapshot.hasData
                      ? const ContactsPage()
                      : const AuthPage();
                }
              },
            );
          }
        });
  }
}

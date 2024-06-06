import 'package:chat/components/input_message.dart';
import 'package:chat/components/messages.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/notifications/chat_notification_service.dart';
import 'package:chat/pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final String name;
  const ChatPage({super.key, required this.chatId, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(name), actions: [
          Consumer<ChatNotificationService>(
            builder: (context, value, child) => Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications),
                ),
                if (value.items.isNotEmpty)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: CircleAvatar(
                      radius: 10,
                      child: FittedBox(
                        child: Text(
                            value.items.length >= 100
                                ? '+99'
                                : value.items.length.toString(),
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                AuthService().logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child:
                    ListTile(leading: Icon(Icons.logout), title: Text('Sair')),
              ),
            ],
          )
        ]),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: Messages(chatId: chatId)),
              InputMessage(chatId: chatId),
            ],
          ),
        ));
  }
}

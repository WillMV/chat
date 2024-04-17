import 'package:chat/components/input_massage.dart';
import 'package:chat/components/messages.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Chat'), actions: [
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
        body: const SafeArea(
          child: Column(
            children: [
              Expanded(child: Messages()),
              InputMessage(),
            ],
          ),
        ));
  }
}

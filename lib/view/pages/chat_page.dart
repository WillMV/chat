import 'package:chat/view/components/input_message.dart';
import 'package:chat/view/components/messages.dart';
import 'package:chat/view/components/notification_icon_button.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final String name;
  const ChatPage({super.key, required this.chatId, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(name), actions: const [
          NotificationIconButton(),
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

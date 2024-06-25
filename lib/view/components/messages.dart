import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/chat_controller.dart';
import 'package:chat/view/components/message_bubble.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatelessWidget {
  final String chatId;
  const Messages({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context);
    final currentUser = Provider.of<AuthController>(context).currentUser;

    return StreamBuilder<List<ChatMessage?>>(
      stream: chatController.messagesStream(chatId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            dragStartBehavior: DragStartBehavior.down,
            itemBuilder: (context, index) => MessageBubble(
              key: ValueKey(snapshot.data![index]!.id),
              message: snapshot.data![index]!,
              belongsCurrentUser:
                  currentUser!.id == snapshot.data![index]!.userId,
            ),
          );
        } else {
          return const Center(
            child: Text('Vácuo..'),
          );
        }
      },
    );
  }
}

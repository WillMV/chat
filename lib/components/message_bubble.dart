import 'dart:io';

import 'package:chat/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool belongsCurrentUser;

  static const _defaultImg = 'assets/images/avatar.png';

  const MessageBubble({
    super.key,
    required this.message,
    required this.belongsCurrentUser,
  });

  Widget _showUserImg() {
    ImageProvider? provider;
    final uri = Uri.parse(message.userImage);

    if (uri.path.contains(_defaultImg)) {
      provider = AssetImage(uri.toString());
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundImage: provider,
      radius: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> userInfo = [
      Padding(
        padding: belongsCurrentUser
            ? const EdgeInsets.only(left: 8)
            : const EdgeInsets.only(right: 8),
        child: _showUserImg(),
      ),
      Text(
        message.userName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: belongsCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: belongsCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Row(
                children:
                    belongsCurrentUser ? userInfo.reversed.toList() : userInfo,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8),
                  decoration: BoxDecoration(
                    color: belongsCurrentUser ? Colors.grey : Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      message.text,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

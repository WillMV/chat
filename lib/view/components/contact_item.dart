import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/utils/show_user_image.dart';
import 'package:chat/view/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactItem extends StatefulWidget {
  final String contactId;
  final String chatId;
  const ContactItem({super.key, required this.contactId, required this.chatId});

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return FutureBuilder(
      future: userController.getUserById(widget.contactId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: LinearProgressIndicator(),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          //TODO: Provisório, implementar snackBar? após 5 segs retornar
          Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final user = snapshot.data!;
        return ListTile(
          key: const Key('contact_item'),
          title: Text(user.name),
          leading: showUserImg(user.imageUrl),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  chatId: widget.chatId,
                  name: user.name,
                ),
              )),
        );
      },
    );
  }
}

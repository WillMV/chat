import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/view/components/add_contact_input.dart';
import 'package:chat/view/components/contact_item.dart';
import 'package:chat/view/components/notification_icon_button.dart';
import 'package:chat/view/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contatos',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          const NotificationIconButton(),
          PopupMenuButton(
            initialValue: 0,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 2,
                child: Text('Configurações'),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                authController.logout();
              }

              if (value == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: userController.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Que tal adicionar alguém?'),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Que tal adicionar alguém?'),
            );
          }

          final data = snapshot.data;

          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) =>
                data[index].users[0] != authController.currentUser!.id
                    ? ContactItem(
                        contactId: snapshot.data![index].users[0],
                        chatId: snapshot.data![index].id!,
                      )
                    : ContactItem(
                        contactId: snapshot.data![index].users[1],
                        chatId: snapshot.data![index].id!,
                      ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.person_add),
          onPressed: () => showModalBottomSheet(
              context: context,
              builder: (context) => const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 18,
                    ),
                    child: AddContactInput(),
                  ))),
    );
  }
}

import 'package:chat/components/add_contact_input.dart';
import 'package:chat/components/contact_item.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/user/user_service.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 18),
                            child: AddContactInput(),
                          ));
                },
                icon: const Icon(Icons.person_add_alt_1))
          ],
        ),
        body: StreamBuilder(
          stream: UserService().getContacts(),
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
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) =>
                  data[index].users[0] != AuthService().currentUser!.id
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
        ));
  }
}

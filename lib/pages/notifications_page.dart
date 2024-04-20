import 'package:chat/core/services/notifications/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ChatNotificationService>(
        builder: (context, value, child) => ListView.builder(
          itemCount: value.items.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ValueKey(value.items[index]),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => value.delete(index),
              background: Container(
                decoration: const BoxDecoration(color: Colors.red),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.delete),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(value.items[index].title),
                    subtitle: Text(value.items[index].body),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:chat/core/services/notifications/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatNotificationService notifications = Provider.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: notifications.items.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey(notifications.items[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => notifications.delete(index),
            background: Container(
              decoration: const BoxDecoration(color: Colors.red),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.delete),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(notifications.items[index].title),
                  subtitle: Text(notifications.items[index].body),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

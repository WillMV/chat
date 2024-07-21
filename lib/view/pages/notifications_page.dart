import 'package:chat/core/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notifications = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              notifications.deleteAll();
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Deletar tudo',
          )
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.notificationItems.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ValueKey(
                "notification_${notifications.notificationItems[index]}"),
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
                  title: Text(notifications.notificationItems[index].title),
                  subtitle: Text(notifications.notificationItems[index].body),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

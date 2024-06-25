import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/view/pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationController>(
      builder: (context, value, child) => Stack(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
          if (value.notificationItems.isNotEmpty)
            Positioned(
              right: 5,
              top: 5,
              child: CircleAvatar(
                radius: 10,
                child: FittedBox(
                  child: Text(
                      value.notificationItems.length >= 100
                          ? '+99'
                          : value.notificationItems.length.toString(),
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

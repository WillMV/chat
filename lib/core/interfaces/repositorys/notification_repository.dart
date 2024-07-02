import 'package:chat/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class INotificationRepository {
  final FirebaseMessaging messaging;
  final FlutterSecureStorage storage;

  INotificationRepository({
    required this.messaging,
    required this.storage,
  });

  List<ChatNotification> notificationItems();
  Future<void> save(ChatNotification notification);
  Future<void> delete(int index);
  Future<void> deleteAll();
  Future<void> init();
}

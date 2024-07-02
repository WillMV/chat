import 'dart:convert';
import 'package:chat/core/interfaces/repositorys/notification_repository.dart';
import 'package:chat/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRepository extends INotificationRepository {
  NotificationRepository({required super.messaging, required super.storage});

  final String _notificationKey = 'notifications';

  final List<ChatNotification> _items = [];

  @override
  List<ChatNotification> notificationItems() {
    return [..._items];
  }

  @override
  Future<void> delete(int index) async {
    _items.removeAt(index);
    await storage.write(
      key: _notificationKey,
      value: jsonEncode(_itemsToStringList()),
    );
  }

  @override
  Future<void> deleteAll() async {
    _items.clear();
    await storage.delete(key: _notificationKey);
  }

  @override
  Future<void> save(ChatNotification notification) async {
    _items.add(notification);

    await storage.delete(key: _notificationKey);

    await storage.write(
        key: _notificationKey, value: jsonEncode(_itemsToStringList()));
  }

  @override
  Future<void> init() async {
    if (await _isAuthorized()) {
      await _configureTerminated();
      await _configureBackground();
      await _configureForeground();
      await _getStorageNotifications();
    }
  }

  List<dynamic> _itemsToStringList() {
    return _items.map((e) => e.toJson()).toList();
  }

  Future<bool> _isAuthorized() async {
    final settings = await messaging.requestPermission(
      alert: true,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  void _messageHandler(RemoteMessage? msg) {
    if (msg == null || msg.notification == null) return;
    save(ChatNotification(
      title: msg.notification!.title!,
      body: msg.notification!.body!,
    ));
  }

  Future<void> _configureForeground() async {
    FirebaseMessaging.onMessage.listen((msg) {
      _messageHandler(msg);
    });
  }

  Future<void> _configureBackground() async {
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      _messageHandler(msg);
    });
  }

  Future<void> _configureTerminated() async {
    RemoteMessage? msg = await messaging.getInitialMessage();
    _messageHandler(msg);
  }

  Future<void> _getStorageNotifications() async {
    if (_items.isEmpty) {
      final String? data = await storage.read(key: _notificationKey);

      if (data == null) return;

      final List<dynamic> notifications = jsonDecode(data);
      for (var element in notifications) {
        _items.add(
            ChatNotification(title: element['title'], body: element['body']));
      }
    }
  }
}

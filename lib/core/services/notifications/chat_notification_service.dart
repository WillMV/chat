import 'package:chat/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [];

  List<ChatNotification> get items {
    return [..._items];
  }

  void add(String title, String body) {
    _items.add(ChatNotification(title: title, body: body));
    print(title);
    notifyListeners();
  }

  void delete(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  Future<void> init() async {
    await _configureTerminated();
    await _configureForeground();
    await _configureBackground();
  }

  Future<bool> _isAuthorized() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      sound: true,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  _messageHandler(RemoteMessage? msg) {
    if (msg == null || msg.notification == null) return;
    add(
      msg.notification!.title!,
      msg.notification!.body!,
    );
  }

  Future<void> _configureForeground() async {
    if (await _isAuthorized()) {
      FirebaseMessaging.onMessage.listen((msg) => _messageHandler(msg));
    }
  }

  Future<void> _configureBackground() async {
    if (await _isAuthorized()) {
      FirebaseMessaging.onMessageOpenedApp
          .listen((msg) => _messageHandler(msg));
    }
  }

  Future<void> _configureTerminated() async {
    if (await _isAuthorized()) {
      RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();
      _messageHandler(msg);
    }
  }
}

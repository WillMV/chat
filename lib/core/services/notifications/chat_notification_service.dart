import 'dart:convert';
import 'package:chat/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [];
  final _storage = const FlutterSecureStorage();

  List<ChatNotification> get items {
    return [..._items];
  }

  void add(String title, String body) async {
    _items.add(ChatNotification(title: title, body: body));
    try {
      await _storage.deleteAll();
      await _storage.write(
        key: 'notifications',
        value: jsonEncode(_itemsToStringList()),
      );
    } catch (e) {
      print('ChatNotificationService.add.Error: $e');
    }

    notifyListeners();
  }

  void delete(int index) async {
    _items.removeAt(index);
    await _storage.write(
      key: 'notifications',
      value: jsonEncode(_itemsToStringList()),
    );
    notifyListeners();
  }

  void deleteAll() async {
    _items.clear();
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<void> init() async {
    await _configureTerminated();
    await _configureBackground();
    await _configureForeground();
    await _getStorageNotifications();
  }

  List<dynamic> _itemsToStringList() {
    return _items.map((e) => e.toJson()).toList();
  }

  Future<void> _getStorageNotifications() async {
    if (_items.isEmpty) {
      try {
        final String? data = await _storage.read(key: 'notifications');
        if (data == null) return;
        final List<dynamic> notifications = jsonDecode(data);
        for (var element in notifications) {
          _items.add(
              ChatNotification(title: element['title'], body: element['body']));
        }
        notifyListeners();
      } catch (e) {
        print('ChatNotificationService._getStorageNotifications.Error: $e');
      }
    }
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
      FirebaseMessaging.onMessage.listen((msg) {
        _messageHandler(msg);
      });
    }
  }

  Future<void> _configureBackground() async {
    if (await _isAuthorized()) {
      FirebaseMessaging.onMessageOpenedApp.listen((msg) {
        _messageHandler(msg);
      });
    }
  }

  Future<void> _configureTerminated() async {
    if (await _isAuthorized()) {
      RemoteMessage? msg = await FirebaseMessaging.instance.getInitialMessage();
      _messageHandler(msg);
    }
  }
}

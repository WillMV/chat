import 'package:chat/core/models/chat_notification.dart';
import 'package:flutter/material.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [
    ChatNotification(
      title: 'title',
      body: 'body',
    ),
    ChatNotification(
      title: 'Aviso',
      body: 'Esta é uma msg de aviso, esteja avisado',
    ),
    ChatNotification(
      title: 'Fulano',
      body: 'bla bla bla bla bla bla bla',
    ),
    ChatNotification(
      title: 'Grupo tal',
      body: 'fulano: Bla bla bla bla aqui tbm',
    ),
  ];

  List<ChatNotification> get items {
    return [..._items];
  }

  void add(String title, String body) {
    _items.add(ChatNotification(title: title, body: body));
    notifyListeners();
  }

  void delete(int index) {
    _items.removeAt(index);
  }
}

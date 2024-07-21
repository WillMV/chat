import 'package:chat/core/interfaces/controllers/notification_controller.dart';
import 'package:chat/core/models/chat_notification.dart';
import 'package:chat/core/services/notification_service.dart';
import 'package:flutter/foundation.dart';

class NotificationController extends INotificationController
    with ChangeNotifier {
  late NotificationService _notificationService;

  NotificationController({required super.notificationRepository}) {
    _notificationService =
        NotificationService(notificationRepository: notificationRepository);
  }

  @override
  Future<void> delete(int index) async {
    await _notificationService.delete(index);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await _notificationService.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> init() async {
    await _notificationService.init();
  }

  @override
  List<ChatNotification> get notificationItems =>
      _notificationService.notificationItems;

  @override
  Future<void> save(String title, String body) async {
    _notificationService.save(title, body);
    notifyListeners();
  }
}

import 'package:chat/core/interfaces/services/notification_service.dart';
import 'package:chat/core/models/chat_notification.dart';

class NotificationService extends INotificationService {
  NotificationService({required super.notificationRepository});

  @override
  Future<void> delete(int index) async {
    await notificationRepository.delete(index);
  }

  @override
  Future<void> deleteAll() async {
    await notificationRepository.deleteAll();
  }

  @override
  Future<void> init() async {
    await notificationRepository.init();
  }

  @override
  Future<void> save(String title, String body) async {
    await notificationRepository
        .save(ChatNotification(title: title, body: body));
  }

  @override
  List<ChatNotification> get notificationItems =>
      notificationRepository.notificationItems();
}

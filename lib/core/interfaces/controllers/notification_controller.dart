import 'package:chat/core/interfaces/controllers/controller.dart';
import 'package:chat/core/models/chat_notification.dart';
import 'package:chat/core/repositorys/notification_repository.dart';

abstract class INotificationController implements IController {
  final NotificationRepository notificationRepository;

  INotificationController({required this.notificationRepository});

  List<ChatNotification> get notificationItems;
  Future<void> save(String title, String body);
  Future<void> delete(int index);
  Future<void> deleteAll();
  Future<void> init();
}

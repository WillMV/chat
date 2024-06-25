import 'package:chat/core/interfaces/repositorys/notification_repository.dart';
import 'package:chat/core/interfaces/services/service.dart';
import 'package:chat/core/models/chat_notification.dart';

abstract class INotificationService implements IService {
  final INotificationRepository notificationRepository;

  INotificationService({required this.notificationRepository});

  List<ChatNotification> get notificationItems;
  Future<void> save(String title, String body);
  Future<void> delete(int index);
  Future<void> deleteAll();
  Future<void> init();
}

import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/core/models/chat_notification.dart';
import 'package:chat/core/repositorys/notification_repository.dart';
import 'package:chat/view/pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNotificationRepository with Mock implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockNotificationRepository;

  final mockChatNotification = ChatNotification(title: 'title', body: 'body');

  Widget testable(Widget child) {
    return ChangeNotifierProvider(
      create: (context) => NotificationController(
          notificationRepository: mockNotificationRepository),
      child: MaterialApp(home: child),
    );
  }

  setUp(() {
    mockNotificationRepository = MockNotificationRepository();
  });

  group('Testes de tela de notificação', () {
    testWidgets('Verifica se nada aparece se não há notificação',
        (tester) async {
      when(() => mockNotificationRepository.notificationItems()).thenReturn([]);

      await tester.pumpWidget(testable(const NotificationsPage()));

      expect(find.byType(Dismissible), findsNothing);
    });
    testWidgets(
        'Verifica se aparece somente uma notificação em tela ao ter uma notificação',
        (tester) async {
      when(() => mockNotificationRepository.notificationItems())
          .thenReturn([mockChatNotification]);

      await tester.pumpWidget(testable(const NotificationsPage()));

      expect(find.byType(Dismissible), findsOne);
    });

    testWidgets('Verifica se exclui todas as notificações em tela',
        (tester) async {
      final mockItems = [
        mockChatNotification,
        mockChatNotification,
        mockChatNotification
      ];

      when(() => mockNotificationRepository.notificationItems())
          .thenReturn(mockItems);

      when(() => mockNotificationRepository.deleteAll()).thenAnswer((_) async {
        mockItems.clear();
      });

      await tester.pumpWidget(testable(const NotificationsPage()));

      final excludeButton = find.byTooltip('Deletar tudo');

      expect(find.byType(Dismissible), findsExactly(3));

      await tester.tap(excludeButton);
      await tester.pump();

      expect(find.byType(Dismissible), findsNothing);
    });
  });
}

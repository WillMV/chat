import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/chat_controller.dart';
import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:chat/core/repositorys/chat_repository.dart';
import 'package:chat/core/repositorys/notification_repository.dart';
import 'package:chat/view/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthRepository with Mock implements AuthRepository {}

class MockChatRepository with Mock implements ChatRepository {}

class MockNotificationRepository with Mock implements NotificationRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockChatRepository mockChatRepository;
  late MockNotificationRepository mockNotificationRepository;

  final currentUser =
      ChatUser(id: 'id', email: 'email@email', name: 'name', imageUrl: '');

  Widget testable(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              AuthController(authRepository: mockAuthRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ChatController(chatRepository: mockChatRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationController(
              notificationRepository: mockNotificationRepository),
        )
      ],
      child: MaterialApp(home: child),
    );
  }

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
    mockChatRepository = MockChatRepository();
    mockNotificationRepository = MockNotificationRepository();

    when(
      () => mockNotificationRepository.notificationItems(),
    ).thenReturn([]);

    when(
      () => mockAuthRepository.currentUser(),
    ).thenReturn(currentUser);
  });

  group('Testes de tela de chat', () {
    testWidgets('Verifica se aparece corretamente o nome do contato na Appbar',
        (tester) async {
      when(
        () => mockChatRepository.messagesStream('chatId'),
      ).thenAnswer((_) {
        return Stream.multi((e) {
          e.add([
            ChatMessage(
              id: 'id',
              text: 'msg_text_01',
              createdAt: DateTime.now(),
              userId: 'userId',
              userName: 'userName',
              userImage: 'userImage',
            )
          ]);
        });
      });
      await tester
          .pumpWidget(testable(const ChatPage(chatId: 'chatId', name: 'name')));

      expect(find.widgetWithText(AppBar, 'name'), findsOne);
    });

    testWidgets('Verifica se aparece as mensagens existentes', (tester) async {
      when(
        () => mockChatRepository.messagesStream('chatId'),
      ).thenAnswer((_) {
        return Stream.multi((e) {
          e.add([
            ChatMessage(
              id: 'id',
              text: 'msg_text_01',
              createdAt: DateTime.now(),
              userId: 'userId',
              userName: 'userName',
              userImage: 'userImage',
            )
          ]);
        });
      });
      await tester
          .pumpWidget(testable(const ChatPage(chatId: 'chatId', name: 'name')));

      expect(find.byType(CircularProgressIndicator), findsOne);

      await tester.pump();

      expect(find.text('msg_text_01'), findsOne);
    });

    testWidgets('Verifica se aparece uma nova mensagem ao enviar',
        (tester) async {
      const chatId = 'chatId';

      final List<ChatMessage> messages = [];

      final message = ChatMessage(
        id: '',
        text: 'msg_text',
        createdAt: DateTime.now(),
        userId: currentUser.id,
        userName: currentUser.name,
        userImage: currentUser.imageUrl,
      );

      when(() => mockChatRepository.save(
            chatId: chatId,
            text: message.text,
            userId: currentUser.id,
            userImage: currentUser.imageUrl ?? 'assets/images/avatar.png',
            userName: currentUser.name,
          )).thenAnswer((_) async {
        messages.add(message);
        return message;
      });

      when(() => mockChatRepository.messagesStream(chatId))
          .thenAnswer((_) => Stream.multi((p0) {
                p0.add(messages);
              }));

      await tester.pumpWidget(
          testable(const ChatPage(chatId: chatId, name: 'userName')));

      final sendButton = find.byKey(const Key('send_btn'));
      final msgInput = find.byKey(const Key('msg_input'));

      await tester.tap(msgInput);
      await tester.pump();

      await tester.enterText(msgInput, message.text);
      await tester.pump();

      await tester.tap(sendButton);
      await tester.pump();

      expect(find.text(message.text), findsOne);
    });
  });
}

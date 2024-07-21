import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/core/models/chat_contact.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:chat/core/repositorys/notification_repository.dart';
import 'package:chat/core/repositorys/user_repository.dart';
import 'package:chat/view/pages/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockUserRepository with Mock implements UserRepository {}

class MockAuthRepository with Mock implements AuthRepository {}

class MockNotificationRepository with Mock implements NotificationRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;
  late MockNotificationRepository mockNotificationRepository;

  final chatContact = ChatContact(id: '', users: ['', '']);
  final chatUser = ChatUser(id: 'id', email: 'email', name: 'name');

  Widget testable(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              AuthController(authRepository: mockAuthRepository),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              UserController(userRepository: mockUserRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationController(
              notificationRepository: mockNotificationRepository),
        ),
      ],
      child: MaterialApp(home: child),
    );
  }

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
    mockNotificationRepository = MockNotificationRepository();

    when(
      () => mockNotificationRepository.notificationItems(),
    ).thenReturn([]);

    when(
      () => mockAuthRepository.currentUser(),
    ).thenReturn(chatUser);
  });

  group('Testes da tela de contatos', () {
    testWidgets('Verifica se aparece a quantidade correta de contatos na tela',
        (tester) async {
      when(() => mockUserRepository.getUserContacts()).thenAnswer(
          (invocation) => Stream.multi((e) => e.add([chatContact])));

      when(() => mockUserRepository.getUserById(''))
          .thenAnswer((_) async => chatUser);

      await tester.pumpWidget(testable(const ContactsPage()));
      await tester.pumpAndSettle();

      expect(find.text('name'), findsOne);
      expect(find.byKey(const Key('contact_item')), findsOne);
    });
  });
}

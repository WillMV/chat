import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/notification_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:chat/core/repositorys/notification_repository.dart';
import 'package:chat/core/repositorys/user_repository.dart';
import 'package:chat/view/pages/auth_or_app_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockUserRepository with Mock implements UserRepository {}

class MockAuthRepository with Mock implements AuthRepository {}

class MockNotificationRepository with Mock implements NotificationRepository {}

void main() {
  late MockNotificationRepository mockNotificationRepository;
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;
  late AuthController authController;
  late NotificationController notificationController;
  late UserController userController;

  Widget _testable() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => notificationController),
          ChangeNotifierProvider(create: (_) => authController),
          ChangeNotifierProvider(create: (_) => userController),
        ],
        child: const MaterialApp(
          home: AuthOrAppPage(),
        ));
  }

  setUpAll(() {
    mockNotificationRepository = MockNotificationRepository();
    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();

    userController = UserController(userRepository: mockUserRepository);
    authController = AuthController(authRepository: mockAuthRepository);
    notificationController = NotificationController(
        notificationRepository: mockNotificationRepository);
  });

  group('Testa a tela de carregamento', () {
    testWidgets('Deve exibir tela de carregamento inicialmente.',
        (tester) async {
      await tester.pumpWidget(_testable());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    testWidgets('Deve exibir tela de carregamento após o init.',
        (tester) async {
      when(
        () => mockNotificationRepository.init(),
      ).thenAnswer((_) async {
        Future.delayed(const Duration(seconds: 1));
      });

      // when(() => mockAuthRepository.userChanges).thenAnswer((_) {
      //   return Stream.multi((p0) {}) as Stream<ChatUser?> Function();
      // });

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => notificationController),
          ChangeNotifierProvider(create: (_) => authController),
          ChangeNotifierProvider(create: (_) => userController),
        ],
        child: const MaterialApp(
          home: AuthOrAppPage(),
        ),
      ));

      await tester.pump(const Duration(seconds: 10));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

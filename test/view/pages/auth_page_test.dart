import 'package:chat/core/controller/auth_controller.dart';
import 'package:chat/core/controller/user_controller.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:chat/core/repositorys/user_repository.dart';
import 'package:chat/view/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthRepository with Mock implements AuthRepository {}

class MockUserRepository with Mock implements UserRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;

  const email = 'email@email.com';
  const name = 'name';
  const password = 'password';

  final emailField = find.byKey(const ValueKey('email'));
  final passwordField = find.byKey(const ValueKey('password'));
  final submitButton = find.byKey(const Key('submit_button'));
  final loginOrSingupButton = find.byKey(const Key('login_or_singup_button'));
  final nameValidator = find.byKey(const ValueKey('name_validator'));

  final chatUser = ChatUser(id: '', email: email, name: name);

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
      ],
      child: MaterialApp(home: child),
    );
  }

  setUpAll(() {
    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
  });
  group('Testes de tela de login', () {
    testWidgets(
        'Se aparece os campos de email, senha e botões de submit e trocar modo',
        (tester) async {
      await tester.pumpWidget(testable(const AuthPage()));

      expect(emailField, findsOne);
      expect(passwordField, findsOne);
      expect(submitButton, findsOne);
      expect(loginOrSingupButton, findsOne);
      expect(nameValidator, findsNothing);
    });

    testWidgets(
        'Se ao trocar o de login para singup ocorre corretamente as mudanças de tela',
        (tester) async {
      await tester.pumpWidget(testable(const AuthPage()));

      when(() => mockUserRepository.getUserByName(name))
          .thenAnswer((_) async => null);

      await tester.tap(loginOrSingupButton);
      await tester.pumpAndSettle();

      expect(nameValidator, findsOne);
    });

    testWidgets(
        'Se apresenta mensagem de erro ao fazer login com os campos vazios',
        (tester) async {
      await tester.pumpWidget(testable(const AuthPage()));
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Email informado não é valido'), findsOne);
      expect(find.text('A senha deve ter ao menos 6 caracteres'), findsOne);
    });
  });

  testWidgets(
      'Se ao inserir um apelido já existente mostra o icone de invalido',
      (tester) async {
    when(
      () => mockUserRepository.getUserByName('text'),
    ).thenAnswer((_) async => chatUser);

    await tester.pumpWidget(testable(const AuthPage()));

    await tester.tap(loginOrSingupButton);
    await tester.pumpAndSettle();

    await tester.tap(nameValidator);
    await tester.pumpAndSettle();

    await tester.enterText(nameValidator, 'text');
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close), findsOne);
  });

  testWidgets('Se ao inserir um apelido inexistente mostra o icone de valido',
      (tester) async {
    when(
      () => mockUserRepository.getUserByName('text'),
    ).thenAnswer((invocation) async => null);

    await tester.pumpWidget(testable(const AuthPage()));
    await tester.tap(loginOrSingupButton);
    await tester.pumpAndSettle();
    await tester.enterText(nameValidator, 'text');
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byIcon(Icons.check), findsOne);
  });

  testWidgets(
      'Se aparece mensagem de erro ao realizar login com credenciais incorretas',
      (tester) async {
    final firebaseException = FirebaseAuthException(
        code: 'invalid-credential',
        message:
            'The supplied auth credential is incorrect, malformed or has expired.');

    when(
      () => mockAuthRepository.login(email, password),
    ).thenAnswer((_) async {
      throw firebaseException;
    });

    when(() => mockUserRepository.getUserByName(name))
        .thenAnswer((_) async => chatUser);

    await tester.pumpWidget(testable(const AuthPage()));

    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Login ou senha incorretos'), findsOne);
  });

  testWidgets(
      'Se aparece mensagem de erro ao realizar signup com credenciais já existentes',
      (tester) async {
    final firebaseException = FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'The email address is already in use by another account.');

    when(
      () => mockAuthRepository.signup(email, password, name),
    ).thenAnswer((_) async {
      throw firebaseException;
    });

    when(() => mockUserRepository.getUserByName(""))
        .thenAnswer((_) async => null);

    when(() => mockUserRepository.getUserByName(name))
        .thenAnswer((_) async => null);

    await tester.pumpWidget(testable(const AuthPage()));

    await tester.tap(loginOrSingupButton);
    await tester.pumpAndSettle();

    await tester.tap(nameValidator);
    await tester.pumpAndSettle();

    await tester.enterText(nameValidator, name);
    await tester.pumpAndSettle();

    await tester.tap(emailField);
    await tester.pumpAndSettle();

    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();

    await tester.tap(passwordField);
    await tester.pumpAndSettle();

    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();

    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Email já cadastrado.'), findsOne);
  });
}

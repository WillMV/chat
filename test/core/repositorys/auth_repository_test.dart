import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/repositorys/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRepository authRepository;

  setUpAll(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authRepository = AuthRepository(auth: mockFirebaseAuth);
  });

  group('Testa a função login', () {
    test('Deve lançar uma Exception quando o login não é bem-sucedido',
        () async {
      // Arrange
      final mockUserCredential = MockUserCredential();

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockUserCredential);

      //Act

      //Assert
      expect(
          () async =>
              await authRepository.login('email@email.com', 'password1'),
          throwsException);

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email@email.com',
            password: 'password1',
          )).called(1);
    });

    test('Não deve lançar uma Exception quando o login é bem-sucedido',
        () async {
      // Arrange
      final mockUserCredential = MockUserCredential();

      when(() => mockUserCredential.user).thenReturn(MockUser());

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockUserCredential);

      //Act

      //Assert
      expect(
          () async =>
              await authRepository.login('email@email.com', 'password1'),
          returnsNormally);

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email@email.com',
            password: 'password1',
          )).called(1);
    });
  });

  group('Testa a função userChanges', () {
    test('Se altera o currentUser corretamente em caso de login', () async {
      //Arrenge
      final mockUserCredential = MockUserCredential();

      final mockUser = MockUser();

      when(
        () => mockUser.email,
      ).thenReturn('email@email.com');

      when(
        () => mockUser.displayName,
      ).thenReturn('Name');

      when(
        () => mockUser.uid,
      ).thenReturn('id');

      when(() => mockUserCredential.user).thenReturn(mockUser);

      when(
        () => mockFirebaseAuth.authStateChanges(),
      ).thenAnswer((invocation) => Stream.multi((_) {
            _.add(mockUser);
          }));

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockUserCredential);

      //Act

      await authRepository.login('email@email.com', 'password');

      final result = await authRepository.userChanges().first;
      final currenteUser = authRepository.currentUser();
      //Assert

      expect(result, isInstanceOf<ChatUser>());
      expect(currenteUser, isInstanceOf<ChatUser>());
    });

    test('Se altera o currentUser corretamente em caso de logout', () async {
      //Arrenge
      final mockUserCredential = MockUserCredential();

      final mockUser = MockUser();

      when(
        () => mockUser.email,
      ).thenReturn('email@email.com');

      when(
        () => mockUser.displayName,
      ).thenReturn('Name');

      when(
        () => mockUser.uid,
      ).thenReturn('id');

      when(() => mockUserCredential.user).thenReturn(mockUser);

      when(() => mockFirebaseAuth.signOut()).thenAnswer((invocation) async {});

      when(
        () => mockFirebaseAuth.authStateChanges(),
      ).thenAnswer((invocation) => Stream.multi((state) {
            authRepository.currentUser() == null
                ? state.add(mockUser)
                : state.add(null);
          }));

      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockUserCredential);

      //Act
      await authRepository.login('email@email.com', 'password');

      await authRepository.logout();

      final currenteUser = authRepository.currentUser();

      //Assert
      expect(currenteUser, isNull);
    });
  });
}

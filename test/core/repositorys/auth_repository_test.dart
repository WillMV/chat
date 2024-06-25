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

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authRepository = AuthRepository(auth: mockFirebaseAuth);
  });

  test('Deve lançar uma Exception quando o login não é bem-sucedido', () async {
    // Arrange
    final mockUserCredential = MockUserCredential();

    when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => mockUserCredential);

    //Act

    //Assert
    expect(
        () async => await authRepository.login('email@email.com', 'password1'),
        throwsException);

    verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'email@email.com',
          password: 'password1',
        )).called(1);
  });

  test('Não deve lançar uma Exception quando o login é bem-sucedido', () async {
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
        () async => await authRepository.login('email@email.com', 'password1'),
        returnsNormally);

    verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'email@email.com',
          password: 'password1',
        )).called(1);
  });
}

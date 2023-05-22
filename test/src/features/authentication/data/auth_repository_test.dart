@Timeout(Duration(milliseconds: 500))
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart' as firebase_mocks;
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRepository authRepository;
  late firebase_mocks.MockUser testUser; // Declare a MockUser
  late MockUserCredential userCredential;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(FakeAuthCredential());
    registerFallbackValue(const Duration(seconds: 120));
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authRepository = AuthRepository(auth: mockFirebaseAuth);
    testUser = firebase_mocks.MockUser(); // Initialize a MockUser
    userCredential = MockUserCredential();
    mockUser = MockUser();
  });

  group('AuthRepository test', () {
    //currentUser test
    test('returns current user', () {
      // Setup the test
      when(() => mockFirebaseAuth.currentUser).thenReturn(testUser);
      // Call the method and assert expectations
      expect(authRepository.currentUser, equals(testUser));
    }, timeout: const Timeout(Duration(milliseconds: 500)));

//authStateChanges test
    test('authStateChanges emits values when user authentication state changes',
        () async {
      // Assume that authStateChanges initially emits a null user.
      when(mockFirebaseAuth.authStateChanges)
          .thenAnswer((_) => Stream.value(null));

      // Assert: Verify that the stream initially emits a null user.
      await expectLater(authRepository.authStateChanges(), emits(null));

      // Arrange: Change the return value of authStateChanges to emit a non-null user.
      when(mockFirebaseAuth.authStateChanges)
          .thenAnswer((_) => Stream.value(testUser));

      // Assert: Verify that the stream now emits the mock user.
      await expectLater(authRepository.authStateChanges(), emits(testUser));
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test(
        'verifyPhoneNumber calls FirebaseAuth verifyPhoneNumber with correct arguments',
        () async {
      // Arrange
      const phoneNumber = '+15551234567';

      void verificationFailed(FirebaseAuthException e) {}

      void codeSent(String verId, int? forceResendToken) {}
      void codeAutoRetrievalTimeout(String verId) {}

      when(() => mockFirebaseAuth.verifyPhoneNumber(
              phoneNumber: any(named: 'phoneNumber'),
              verificationFailed: any(named: 'verificationFailed'),
              codeSent: any(named: 'codeSent'),
              codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
              timeout: any(named: 'timeout'),
              verificationCompleted: any(named: 'verificationCompleted')))
          .thenAnswer((_) => Future.value());

      // // Act

      await authRepository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      verify(() => mockFirebaseAuth.verifyPhoneNumber(
              phoneNumber: any(named: 'phoneNumber'),
              verificationFailed: any(named: 'verificationFailed'),
              codeSent: any(named: 'codeSent'),
              codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
              timeout: any(named: 'timeout'),
              verificationCompleted: any(named: 'verificationCompleted')))
          .called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('verifyOtpCode calls FirebaseAuth signinWithCredential', () async {
      const otpCode = '123456';
      const verificationId = 'verificationId';

//stub

      when(() => mockFirebaseAuth.signInWithCredential(any()))
          .thenAnswer((_) => Future.value(userCredential));

//Act
      await authRepository.verifyOtpCode(
          otpCode: otpCode, verificationId: verificationId);

//Assert

      verify(() => mockFirebaseAuth.signInWithCredential(any())).called(1);
    });

    test('signOut calls FirebaseAuth signOut', () async {
      when(mockFirebaseAuth.signOut).thenAnswer((_) => Future.value());

      await authRepository.signOut();

      verify(mockFirebaseAuth.signOut).called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

    test('deleteAccount calls FirebaseAuth deleteAccount', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.delete).thenAnswer((_) => Future.value());

      await authRepository.deleteAccount();

      verify(mockUser.delete).called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}

@Timeout(Duration(milliseconds: 500))
import 'package:flutter_folio/src/features/authentication/application/signin_service.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fakes/fake_connection_checker.dart';
import '../../../mocks.dart';

void main() {
  ConnectionChecker withConnectionChecker =
      FakeConnectionChecker(connection: true);
  ConnectionChecker withoutConnectionChecker =
      FakeConnectionChecker(connection: false);
  AuthRepository authRepository = MockAuthRepository();
  // SigninService signinService;

  setUp(() {
    // connectionChecker = MockConnectionChecker();
    // signinService = SigninService(ref: ref)
  });

  SigninService makeConnectionSigninService() {
    final container = ProviderContainer(overrides: [
      connectionCheckerProvider.overrideWithValue(withConnectionChecker),
      authRepositoryProvider.overrideWithValue(authRepository)
    ]);
    addTearDown(container.dispose);
    return container.read(signinServiceProvider);
  }

  SigninService makeNoConnectionSigninService() {
    final container = ProviderContainer(overrides: [
      connectionCheckerProvider.overrideWithValue(withoutConnectionChecker),
      authRepositoryProvider.overrideWithValue(authRepository)
    ]);
    addTearDown(container.dispose);
    return container.read(signinServiceProvider);
  }

  group('SigninService test', () {
    group('verifyPhoneNumber test', () {
      test(
          'verify that verifyPhoneNumber is correctly calling verifyPhoneNumber when connection is true',
          () async {
        //setup
        final signinService = makeConnectionSigninService();
        const phoneNumber = '+15551234567';

        void verificationFailed(_) {}

        void codeSent(_, __) {}
        when(() => authRepository.verifyPhoneNumber(
                phoneNumber: phoneNumber,
                verificationFailed: verificationFailed,
                codeSent: codeSent,
                codeAutoRetrievalTimeout:
                    any(named: 'codeAutoRetrievalTimeout')))
            .thenAnswer((invocation) => Future.value());

        //call
        await signinService.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            codeSent: codeSent,
            verificationFailed: verificationFailed);
        verify(() => authRepository.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout:
                any(named: 'codeAutoRetrievalTimeout'))).called(1);

        // expect(count, 1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));

      test(' verifyPhoneNumber throws a StateError when connection is false',
          () async {
        //setup
        final signinService = makeNoConnectionSigninService();
        const phoneNumber = '+15551234567';

        void verificationFailed(_) {}

        void codeSent(_, __) {}
        when(() => authRepository.verifyPhoneNumber(
                phoneNumber: phoneNumber,
                verificationFailed: verificationFailed,
                codeSent: codeSent,
                codeAutoRetrievalTimeout:
                    any(named: 'codeAutoRetrievalTimeout')))
            .thenAnswer((invocation) => Future.value());

        //call
        Future call = signinService.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            codeSent: codeSent,
            verificationFailed: verificationFailed);

        expect(call, throwsA(isA<StateError>()));
        verifyNever(() => authRepository.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout')));

        // expect(count, 1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });

    group('verifyOptCode test*', () {
      test(
          'verify that authRepository.veiryOtpCode is correctly called when connection is true',
          () async {
        final signinService = makeConnectionSigninService();
        const otpCode = '123456';
        const verificationId = 'veirificationId';
//setup
        when(() => authRepository.verifyOtpCode(
                otpCode: otpCode, verificationId: verificationId))
            .thenAnswer((invocation) => Future.value());
        //call
        await signinService.verifyOtpCode(
            otpCode: otpCode, verificationId: verificationId);

        verify(() => authRepository.verifyOtpCode(
            otpCode: otpCode, verificationId: verificationId)).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(
          'verify that authRepository.veiryOtpCode is not called throws error when connection is false',
          () async {
        final signinService = makeNoConnectionSigninService();
        const otpCode = '123456';
        const verificationId = 'veirificationId';
//setup
        when(() => authRepository.verifyOtpCode(
                otpCode: otpCode, verificationId: verificationId))
            .thenAnswer((invocation) => Future.value());
        //call
        Future call = signinService.verifyOtpCode(
            otpCode: otpCode, verificationId: verificationId);

        expect(call, throwsA(isA<StateError>()));

        verifyNever(() => authRepository.verifyOtpCode(
            otpCode: otpCode, verificationId: verificationId));
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

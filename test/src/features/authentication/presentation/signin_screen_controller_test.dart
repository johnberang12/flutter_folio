import 'package:flutter_folio/src/features/authentication/application/signin_service.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer(MockSigninService signinService) {
    final container = ProviderContainer(
        overrides: [signinServiceProvider.overrideWithValue(signinService)]);

    addTearDown(container.dispose);
    return container;
  }

  late StateError stateError;

  setUp(() {
    stateError = StateError('Something went wrong');
  });

  setUpAll(() {
    registerFallbackValue(const AsyncLoading());
  });

  group('AccountScreen controller test', () {
    test('initial state is AsyncData', () {
      final signinService = MockSigninService();

      final container = makeProviderContainer(signinService);
//create a listener
      final listener = Listener<AsyncValue<void>>();
//listen to the provider and call [listener] when its value changes
      container.listen<AsyncValue<void>>(
          signinScreenControllerProvider, listener,
          fireImmediately: true);
//verify that the controller has an initial value of AsyncData(null)
      verify(() => listener(null, const AsyncData<void>(null)));
//verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      //verify that the accountService.logout() is not called
      verifyNever(() => signinService.verifyPhoneNumber(
          phoneNumber: any(named: 'phoneNumber'),
          codeSent: any(named: 'codeSent'),
          verificationFailed: any(named: 'verificationFailed')));
      //verify that the accountService.deleteAccount() is not called
      verifyNever(() => signinService.verifyOtpCode(
          otpCode: any(named: 'otpCode'),
          verificationId: any(named: 'verificationId')));
    });
    group('verifyPhoneNumber test', () {
      test('verifyPhoneNumber success', () async {
        //* Arrange
        final signinService = MockSigninService();
        when(() => signinService.verifyPhoneNumber(
                phoneNumber: any(named: 'phoneNumber'),
                codeSent: any(named: 'codeSent'),
                verificationFailed: any(named: 'verificationFailed')))
            .thenAnswer((_) => Future.value());
        final container = makeProviderContainer(signinService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            signinScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(signinScreenControllerProvider.notifier);
        await controller.verifyPhoneNumber(
            phoneNumber: '+15551234567',
            codeSent: (_, __) {},
            verificationFailed: (_) {});
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(any(that: isA<AsyncLoading>()), data),
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => signinService.verifyPhoneNumber(
            phoneNumber: any(named: 'phoneNumber'),
            codeSent: any(named: 'codeSent'),
            verificationFailed: any(named: 'verificationFailed'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 700)));
      test('verifyPhoneNumber Failed', () async {
        //* Arrange
        final signinService = MockSigninService();
        when(() => signinService.verifyPhoneNumber(
                phoneNumber: any(named: 'phoneNumber'),
                codeSent: any(named: 'codeSent'),
                verificationFailed: any(named: 'verificationFailed')))
            .thenAnswer((_) => Future.error(stateError));
        final container = makeProviderContainer(signinService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            signinScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(signinScreenControllerProvider.notifier);
        await controller.verifyPhoneNumber(
            phoneNumber: '+15551234567',
            codeSent: (_, __) {},
            verificationFailed: (_) {});
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => signinService.verifyPhoneNumber(
            phoneNumber: any(named: 'phoneNumber'),
            codeSent: any(named: 'codeSent'),
            verificationFailed: any(named: 'verificationFailed'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 700)));
    });
    group('verifyOtpCode test', () {
      test('varifyOtpCOde success', () async {
        //* Arrange
        final signinService = MockSigninService();
        when(() => signinService.verifyOtpCode(
                otpCode: any(named: 'otpCode'),
                verificationId: any(named: 'verificationId')))
            .thenAnswer((_) => Future.value());
        final container = makeProviderContainer(signinService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            signinScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(signinScreenControllerProvider.notifier);
        await controller.verifyOtpCode(
            otpCode: '123456', verificationId: 'verificationId');
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          // () => listener(any(that: isA<AsyncLoading>()), data),
          () => Listener<AsyncLoading>
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => signinService.verifyOtpCode(
            otpCode: any(named: 'otpCode'),
            verificationId: any(named: 'verificationId'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('verifyOtpCode failed', () async {
        //* Arrange
        final signinService = MockSigninService();
        when(() => signinService.verifyOtpCode(
                otpCode: any(named: 'otpCode'),
                verificationId: any(named: 'verificationId')))
            .thenAnswer((_) => Future.error(stateError));
        final container = makeProviderContainer(signinService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            signinScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(signinScreenControllerProvider.notifier);
        await controller.verifyOtpCode(
            otpCode: '123456', verificationId: 'verificationId');
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          // () => listener(
          //     any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
          () => Listener<AsyncError>
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => signinService.verifyOtpCode(
            otpCode: any(named: 'otpCode'),
            verificationId: any(named: 'verificationId'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

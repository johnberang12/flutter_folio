@Timeout(Duration(milliseconds: 500))
import 'package:flutter_folio/src/features/account/presentation/account_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer(MockAccountService accountService) {
    final container = ProviderContainer(
        overrides: [accountServiceProvider.overrideWithValue(accountService)]);

    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading());
  });

  group('AccountScreenController test', () {
    test('initial state is AsyncData', () {
      final accountService = MockAccountService();

      final container = makeProviderContainer(accountService);
//create a listener
      final listener = Listener<AsyncValue<void>>();
//listen to the provider and call [listener] when its value changes
      container.listen<AsyncValue<void>>(
          accountScreenControllerProvider, listener,
          fireImmediately: true);
//verify that the controller has an initial value of AsyncData(null)
      verify(() => listener(null, const AsyncData<void>(null)));
//verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      //verify that the accountService.logout() is not called
      verifyNever(accountService.logout);
      //verify that the accountService.deleteAccount() is not called
      verifyNever(() => accountService.deleteAccount(
          confirmation: any(named: 'confirmation')));
    });
    group('logout test', () {
      test('logout success', () async {
        //* Arrange
        final accountService = MockAccountService();

        when(accountService.logout).thenAnswer((invocation) => Future.value());

        final container = makeProviderContainer(accountService);

        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            accountScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));

        final controller =
            container.read(accountScreenControllerProvider.notifier);
        await controller.logout();

        verifyInOrder([
          //called data then loading
          () => listener(data, any(that: isA<AsyncLoading>())),
          //called loading but data is not longer assigned to prevent updating the UI when page is no longer mounted
          () => Listener<AsyncLoading>,
        ]);

        verifyNoMoreInteractions(listener);
        verify(accountService.logout).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('logout failure', () async {
        //* Arrange
        final error = StateError('Something went wrong');
        final accountService = MockAccountService();

        when(accountService.logout)
            .thenAnswer((invocation) => Future.error(error));

        final container = makeProviderContainer(accountService);

        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            accountScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));

        final controller =
            container.read(accountScreenControllerProvider.notifier);
        await controller.logout();

        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ]);

        verifyNoMoreInteractions(listener);
        verify(accountService.logout).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('deleteAccount test', () {
      test('deleteAccount success', () async {
        //* Arrange
        final accountService = MockAccountService();
        const confirmation = 'DELETE';

        when(() => accountService.deleteAccount(
                confirmation: any(named: 'confirmation')))
            .thenAnswer((invocation) => Future.value());

        final container = makeProviderContainer(accountService);

        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            accountScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));

        final controller =
            container.read(accountScreenControllerProvider.notifier);
        await controller.deleteAccount(confirmation);

        verifyInOrder([
          //called data then loading
          () => listener(data, any(that: isA<AsyncLoading>())),
          //called loading but data is not longer assigned
          //to prevent updating the UI when page is no longer mounted
          () => Listener<AsyncLoading>,
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => accountService.deleteAccount(
            confirmation: any(named: 'confirmation'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('deleteAccount failure', () async {
        //* Arrange
        const confirmation = 'DELETE';
        final error = StateError('Something went wrong');
        final accountService = MockAccountService();

        when(() => accountService.deleteAccount(
                confirmation: any(named: 'confirmation')))
            .thenAnswer((invocation) => Future.error(error));

        final container = makeProviderContainer(accountService);

        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            accountScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));

        final controller =
            container.read(accountScreenControllerProvider.notifier);
        await controller.deleteAccount(confirmation);

        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => accountService.deleteAccount(
            confirmation: any(named: 'confirmation'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

@Timeout(Duration(milliseconds: 500))
import 'package:flutter_folio/src/features/account/presentation/account_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

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

  group('AccountScreen controller test', () {
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
      const data = AsyncData<void>(null);
      verify(() => listener(null, data));
//verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      //verify that the accountService.logout() is not called
      verifyNever(accountService.logout);
      //verify that the accountService.deleteAccount() is not called
      verifyNever(() => accountService.deleteAccount(
          confirmation: any(named: 'confirmation')));
    }, timeout: const Timeout(Duration(milliseconds: 500)));
    group('log out test', () {
      test(' success', () async {
        //* Arrange
        //  when().thenAnswer((_) => Future.value());

        //*call

        //*assert
        //     verifyInOrder([
        //   () => listener(data, any(that: isA<AsyncLoading>())),
        //   () => listener(
        //       any(that: isA<AsyncLoading>()), data),
        // ]);

        // verifyNoMoreInteractions(listener);
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(' failure', () async {
        //* Arrange
        //  final error = Exception('error');
        //  when().thenAnswer((_) => Future.value());

        //*call

        //*assert
        //     verifyInOrder([
        //   () => listener(data, any(that: isA<AsyncLoading>())),
        //   () => listener(
        //       any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        // ]);

        // verifyNoMoreInteractions(listener);
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('deleteteAccount test', () {
      test(' success', () async {
        //* Arrange
        //  when().thenAnswer((_) => Future.value());

        //*call

        //*assert
        //     verifyInOrder([
        //   () => listener(data, any(that: isA<AsyncLoading>())),
        //   () => listener(
        //       any(that: isA<AsyncLoading>()), data),
        // ]);

        // verifyNoMoreInteractions(listener);
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(' failure', () async {
        //* Arrange
        //  final error = Exception('error');
        //  when().thenAnswer((_) => Future.value());

        //*call

        //*assert
        //    verifyInOrder([
        //   () => listener(data, any(that: isA<AsyncLoading>())),
        //   () => listener(
        //       any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        // ]);

        // verifyNoMoreInteractions(listener);
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

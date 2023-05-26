@Timeout(Duration(milliseconds: 500))
import 'package:flutter_folio/src/features/account/presentation/account_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      verify(() => listener(null, const AsyncData<void>(null)));
//verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      //verify that the accountService.logout() is not called
      verifyNever(accountService.logout);
      //verify that the accountService.deleteAccount() is not called
      verifyNever(() => accountService.deleteAccount(
          confirmation: any(named: 'confirmation')));
    });
    group('log out test', () {
      test('', () async {
        //* Arrange
        //  when().thenAnswer((invocation) => Future.value());

        //*call

        //*assert
        // expect(, );
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('', () async {
        //* Arrange
        //  when().thenAnswer((invocation) => Future.value());

        //*call

        //*assert
        // expect(, );
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('deleteteAccount test', () {
      test('', () async {
        //* Arrange
        //  when().thenAnswer((invocation) => Future.value());

        //*call

        //*assert
        // expect(, );
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('', () async {
        //* Arrange
        //  when().thenAnswer((invocation) => Future.value());

        //*call

        //*assert
        // expect(, );
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

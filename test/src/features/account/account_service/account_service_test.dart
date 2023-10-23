@Timeout(Duration(milliseconds: 500))
import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fakes/fake_connection_checker.dart';
import '../../../mocks.dart';

void main() {
  AuthRepository authRepository = MockAuthRepository();
  ConnectionChecker withConnectionChecker =
      FakeConnectionChecker(connection: true);
  ConnectionChecker withoutConnectionChecker =
      FakeConnectionChecker(connection: false);

  setUp(() {});

  AccountService makeConnectionAccountService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      connectionCheckerProvider.overrideWithValue(withConnectionChecker)
    ]);

    return container.read(accountServiceProvider);
  }

  AccountService makeNoConnectionAccountService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      connectionCheckerProvider.overrideWithValue(withoutConnectionChecker)
    ]);

    return container.read(accountServiceProvider);
  }

  group('AccountService test', () {
    group('log out test', () {
      test('logout should correctly calling signOut when connection is true',
          () async {
        final accountService = makeConnectionAccountService();

        when(authRepository.signOut).thenAnswer((invocation) => Future.value());
        await accountService.logout();

        verify(authRepository.signOut).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(
          'logout should thows a StateError and not call signOut when connection is false',
          () async {
        final accountService = makeNoConnectionAccountService();
        when(authRepository.signOut).thenAnswer((invocation) => Future.value());
        Future call = accountService.logout();

        expect(call, throwsA(isA<StateError>()));
        verifyNever(authRepository.signOut);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('deleteteAccount test', () {
      test(
          'verify that deleteAccount throws StateError when incorrect param is passed and not call to auth.deleteAccout()',
          () async {
        final accountService = makeConnectionAccountService();
        when(() => accountService.deleteAccount(confirmation: 'DELETE'))
            .thenAnswer((invocation) => Future.value());
        Future call = accountService.deleteAccount(confirmation: 'Delete');
        expect(call, throwsA(isA<StateError>()));
        verifyNever(() => accountService.deleteAccount(confirmation: 'DELETE'));
      }, timeout: const Timeout(Duration(milliseconds: 500)));

      test(
          'verify that deleteAccount is correctly calling authRepo.deleteAccout when connection is true and correct param is passed',
          () async {
        final accountService = makeConnectionAccountService();
        when(() => accountService.deleteAccount(confirmation: 'DELETE'))
            .thenAnswer((invocation) => Future.value());
        await accountService.deleteAccount(confirmation: 'DELETE');
        verify(() => accountService.deleteAccount(confirmation: 'DELETE'))
            .called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));

      test(
          'verify that deleteAccount throws StateError when connection is false and no call to auth.deleteAccount()',
          () async {
        final accountService = makeNoConnectionAccountService();
        when(authRepository.deleteAccount)
            .thenAnswer((invocation) => Future.value());
        Future call = accountService.deleteAccount(confirmation: 'DELETE');
        expect(call, throwsA(isA<StateError>()));
        verifyNever(authRepository.deleteAccount);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

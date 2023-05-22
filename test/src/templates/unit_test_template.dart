@Timeout(Duration(milliseconds: 500))
// import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
// import 'package:flutter_folio/src/utils/connection_checker.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../fakes/fake_connection_checker.dart';
//*uncomment if needed
import 'package:flutter_test/flutter_test.dart';

void main() {
//*uncomment if needed
//   ConnectionChecker withConnectionChecker =
//       FakeConnectionChecker(connection: true);
//   ConnectionChecker withoutConnectionChecker =
//       FakeConnectionChecker(connection: false);

//   setUp(() {});

// //*change the return type and the provider
//   AccountService makeConnectionAccountService() {
//     final container = ProviderContainer(overrides: [
//       connectionCheckerProvider.overrideWithValue(withConnectionChecker)
//     ]);

//     return container.read(accountServiceProvider);
//   }

//   AccountService makeNoConnectionAccountService() {
//     final container = ProviderContainer(overrides: [
//       connectionCheckerProvider.overrideWithValue(withoutConnectionChecker)
//     ]);

//     return container.read(accountServiceProvider);
//   }

  group('AccountService test', () {
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

@Timeout(Duration(milliseconds: 500))
// import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  // AccountService makeConnectionAccountService() {
  //   final container = ProviderContainer(overrides: [
  //     connectionCheckerProvider.overrideWithValue(withConnectionChecker)
  //   ]);
// addTearDown(() => container.dispose());
  //   return container.read(accountServiceProvider);
  // }

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
        //  when().thenAnswer((_) => Future.value());

        //*call

        //*assert
        // expect(, );
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('', () async {
        //* Arrange
        //  when().thenAnswer((_) => Future.value());

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
        //  when().thenAnswer((_) => Future.value());

        //*call

        //*assert
        // expect(, );
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('', () async {
        //* Arrange
        //  when().thenAnswer((_) => Future.value());

        //*call

        //*assert
        // expect(, );
        //  verify().called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../../robot.dart';

void main() {
  late AuthRepository authRepository;
  late FirebaseAuth firebaseAuth;
  late User? user;

  setUp(() {
    user = MockUser();
    firebaseAuth = MockFirebaseAuth();
    authRepository = MockAuthRepository();

    when(() => authRepository.currentUser).thenReturn(user);
  });
  testWidgets('Get started buton flow', (tester) async {
    final r = Robot(tester);
    await tester.runAsync(() async {
      await r.pumpMyApp(overrides: [
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
        authRepositoryProvider.overrideWithValue(authRepository),
        authStateChangesProvider.overrideWith((ref) => Stream.value(null))
      ]);

      //expect to find Get started button
      // final getStartedButtonText = find.text('Get started');
      // expect(getStartedButtonText, findsOneWidget);

      // //pump the button
      // await tester.tap(getStartedButtonText);
      // await tester.pumpAndSettle();

      // //expect to find TextFormField
      // final numberTextField = find.byType(TextFormField);
      // expect(numberTextField, findsOneWidget);
    });
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

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

//   testWidgets('landing page return welcome screen when user == null',
//       (tester) async {
//     FlutterError.onError = (FlutterErrorDetails details) {
//       debugPrint(details.toString());
//     };
//     final r = Robot(tester);
//     await tester.runAsync(() async {
//       await r.pumpMyApp(overrides: [
//         firebaseAuthProvider.overrideWithValue(firebaseAuth),
//         authRepositoryProvider.overrideWithValue(authRepository),
//         authStateChangesProvider.overrideWith((ref) => Stream.value(null))
//       ]);

//       final getStartedButtonText = find.text('Get started');
//       expect(getStartedButtonText, findsOneWidget);
//     });
//   });
//   testWidgets('landing page return home screen when user != null',
//       (tester) async {
//     FlutterError.onError = (FlutterErrorDetails details) {
//       debugPrint(details.toString());
//     };
//     final r = Robot(tester);
//     await tester.runAsync(() async {
//       await r.pumpMyApp(overrides: [
//         firebaseAuthProvider.overrideWithValue(firebaseAuth),
//         authRepositoryProvider.overrideWithValue(authRepository),
//         authStateChangesProvider.overrideWith((ref) => Stream.value(user))
//       ]);
// //used to print all the widgets
//       // for (var widget in tester.allWidgets) {
//       //   debugPrint(widget.toString());
//       // }

//       final homeAppBar = find.byKey(kHomeAppbarKey);
//       expect(homeAppBar, findsOneWidget);
//     });
  // });
}

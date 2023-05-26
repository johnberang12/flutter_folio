import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/landing_page.dart';
import 'package:flutter_folio/src/services/firestore_service/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

void main() {
  // late AuthRepository authRepository;
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;

  late User? user;

  setUp(() {
    user = MockUser();
    firestore = FakeFirebaseFirestore();
    auth = MockFirebaseAuth();

    // authRepository = MockAuthRepository();
    // when(() => authRepository.currentUser).thenReturn(user);
  });

  testWidgets('landing page return welcome screen when user == null',
      (tester) async {
    await tester.pumpWidget(ProviderScope(
        overrides: [
          authStateChangesProvider.overrideWith((ref) => Stream.value(null))
        ],
        child: const MaterialApp(
          home: LandingPage(),
        )));
    await tester.pumpAndSettle();
    final getStartedButtonText = find.text('Get started');
    expect(getStartedButtonText, findsOneWidget);
  });
  testWidgets('landing page return home screen when user != null',
      (tester) async {
    when(() => auth.currentUser).thenReturn(user);
    await tester.runAsync(() async {
      await tester.pumpWidget(ProviderScope(
          overrides: [
            authStateChangesProvider.overrideWith((ref) => Stream.value(user)),
            firestoreProvider.overrideWithValue(firestore),
            firebaseAuthProvider.overrideWithValue(auth),
          ],
          child: const MaterialApp(
            home: LandingPage(),
          )));

      await tester.pump();
      final getStartedButtonText = find.text('Get started');
      expect(getStartedButtonText, findsNothing);
    });
  });
}

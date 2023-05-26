// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/src/features/account/presentation/account_screen.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/authentication/presentation/phone_number_input_field.dart';
import 'package:flutter_folio/src/features/authentication/presentation/pinput.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_with_phone_button.dart';
import 'package:flutter_folio/src/features/introduction/welcome_screen.dart';
import 'package:flutter_folio/src/features/product/presentation/product_list/home_appbar.dart';
import 'package:flutter_folio/src/features/routing/app_router/app_route.dart';
import 'package:flutter_folio/src/features/routing/bottom_natigation/cupertino_home_scaffold.dart';
import 'package:flutter_folio/src/features/routing/bottom_natigation/tab_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class AuthRobot {
  AuthRobot({
    required this.tester,
  });
  final WidgetTester tester;
//*logout
  Future<void> goToHome() async {
    final container = ProviderContainer();
    final location = container.read(goRouterProvider).location;
    if (location != '/home') {
      container.read(goRouterProvider).goNamed(AppRoute.home.name);
    }
    await tester.pumpAndSettle();
    expectCupertinoHomeScaffold();
  }

  void expectCupertinoHomeScaffold() {
    final cupertinoHomeScaffold = find.byType(CupertinoHomeScaffold);
    expect(cupertinoHomeScaffold, findsOneWidget);
  }

  Future<void> goToAccountScreen() async {
    await goToHome();
    final accountTabIcon = find.byKey(kAccountIconTabKey);
    await tester.tap(accountTabIcon);
    await tester.pumpAndSettle();
    final accountScreenTab = find.byType(AccountScreen);
    expect(accountScreenTab, findsOneWidget);
    expectLogoutButton();
  }

  void expectLogoutButton() {
    final logoutButton = find.byKey(kLogoutButtonKey);
    expect(logoutButton, findsOneWidget);
  }

  Future<void> tapLogoutAndConfirm() async {
    final logoutButton = find.byKey(kLogoutButtonKey);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    expectLogoutConfirmationDialog();
    await findsOkButtonAndTap();
  }

  void expectLogoutConfirmationDialog() {
    final logoutConfirmationText =
        find.textContaining('Are you sure you want to log out?');
    expect(logoutConfirmationText, findsOneWidget);
  }

  Future<void> findsOkButtonAndTap() async {
    final okButton = find.text('Ok');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }

//*signin with phone number

  Future<void> tapGetStartedButton() async {
    final getStartedButton = find.byKey(kGetStartedButtonKey);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  void expectSigninScreen() async {
    final verifyPhoneNumberButton = find.byKey(kPhoneSigninButtonKey);
    final phoneNumberTextField = find.byKey(kSigninPhoneTextFieldKey);
    expect(verifyPhoneNumberButton, findsOneWidget);
    expect(phoneNumberTextField, findsOneWidget);
  }

  Future<void> enterPhoneNumberAndSubmit() async {
    final phoneNumberTextField = find.byKey(kSigninPhoneTextFieldKey);
    await tester.ensureVisible(phoneNumberTextField);
    await tester.enterText(phoneNumberTextField, '5551234567');
    //pump the screen to update its ui and enable the button
    await tester.pump();
    final verifyPhoneNumberButton = find.byKey(kPhoneSigninButtonKey);
    await tester.tap(verifyPhoneNumberButton);
    await tester.pumpAndSettle();
  }

  Future<void> expectOtpInputForm() async {
    await tester.pump();
    final otpPinputField = find.byType(CustomPinPutWidget);
    expect(otpPinputField, findsOneWidget);
  }

  Future<String?> fetchVerificationCode({int retryCount = 5}) async {
    const projectId = "flutter-folio-6f5bf";

    const url =
        'http://10.0.2.2:9099/emulator/v1/projects/$projectId/verificationCodes';
    await Future.delayed(const Duration(seconds: 1));
    for (var i = 0; i < retryCount; i++) {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final body = await jsonDecode(response.body);
          final codes = body['verificationCodes'] as List?;

          if (codes != null && codes.isNotEmpty) {
            final latestCode = codes.last['code'];

            return latestCode;
          }
        } else {
          debugPrint(
              'Failed to fetch verification codes: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Failed to get response: ${e.toString()}');
      }

      // Wait a second before retrying
      await Future.delayed(const Duration(seconds: 1));
    }
    debugPrint('No verification code found after $retryCount retries.');
    return null;
  }

  Future<void> enterOtpCodeAndSubmit(String otpCode) async {
    // Iterate over each TextField
    for (var i = 0; i < 6; i++) {
      // Find the TextField by index
      final textField = find.byWidgetPredicate(
        (widget) => widget is TextField && widget.key == ValueKey(i),
        description: 'TextField with key $i',
      );

      // expect(textField, findsOneWidget);

      // Enter a digit
      await tester.enterText(textField, otpCode[i]);
    }
    await tester.pump();
    // await tester.pumpAndSettle(const Duration(seconds: 10));
    // await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.pumpAndSettle(const Duration(seconds: 10));
  }

  void expectHomeScreen() {
    // final callback = CallbackDelay();
    // await callback.iterate();
    // await tester.pumpAndSettle(const Duration(seconds: 10));
    final homeAppbar = find.byKey(kHomeAppbarKey);
    expect(homeAppbar, findsOneWidget);
  }

  //** //** //** //** //** */ */ */ */ */ */

  Future<void> pumpWelcomeScreen({List<Override> overrides = const []}) async {
    final container = ProviderContainer();
    await tester.pumpWidget(ProviderScope(
        overrides: overrides,
        child: MaterialApp.router(
          routerConfig: container.read(goRouterProvider),
        )));

    await tester.pumpAndSettle();
  }

  void stubVerifyPhoneNumberMethod(AuthRepository authRepository) {
    when(() => authRepository.verifyPhoneNumber(
          phoneNumber: any(named: 'phoneNumber'),
          verificationFailed: any(named: 'verificationFailed'),
          codeSent: any(named: 'codeSent'),
          codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
        )).thenAnswer((realInvocation) {
      final codeSent = realInvocation.namedArguments[const Symbol('codeSent')];
      if (codeSent is void Function(String, int?)) {
        // The verification code and the code timeout can be replaced by your mock values
        codeSent('mock_verification_code', 120);
      }
      return Future.value();
    });
  }

  void verifyVerifyPhoneNumberIsCalled(AuthRepository authRepository) {
    verify(() => authRepository.verifyPhoneNumber(
            phoneNumber: any(named: 'phoneNumber'),
            verificationFailed: any(named: 'verificationFailed'),
            codeSent: any(named: 'codeSent'),
            codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout')))
        .called(1);
  }

  void stubVerifyOtpCode(AuthRepository authRepository, User? mockUser) {
    when(() => authRepository.verifyOtpCode(
        otpCode: any(named: 'otpCode'),
        verificationId: any(named: 'verificationId'))).thenAnswer((_) async {
      return Future.value();
    });
  }
  // override authStateChanges to return MockUser
  // when(() => authRepository.authStateChanges())
  //     .thenReturn(Stream.value(mockUser));

  // // MockFirebaseAuth.instance.currentUser should return MockUser
  // when(() => authRepository.currentUser).thenReturn(mockUser);

  // await Future.delayed(const Duration(seconds: 1));
  void verifyVerifyOtpCodeIsCalled(AuthRepository authRepository) {
    verify(() => authRepository.verifyOtpCode(
        otpCode: any(named: 'otpCode'),
        verificationId: any(named: 'verificationId'))).called(1);
  }

  void expectGetStartedButton() {
    final getStartedButton = find.byKey(kGetStartedButtonKey);
    expect(getStartedButton, findsOneWidget);
  }
}

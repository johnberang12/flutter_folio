// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_folio/src/my_app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'features/product/product_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester: tester),
        prod = ProductRobot(tester);
  final WidgetTester tester;

  final AuthRobot auth;
  final ProductRobot prod;

  Future<void> pumpMyApp({List<Override> overrides = const []}) async {
    await tester
        .pumpWidget(ProviderScope(overrides: overrides, child: const MyApp()));
    await tester.pumpAndSettle();
  }

  Future<void> logout() async {
    //starts from any screen as long as the tester is loggedIn
    await auth.goToAccountScreen();
    await auth.tapLogoutAndConfirm();
  }

  Future<void> signinWithPhoneNumber() async {
//starts from the welcome screen because the tester is not loggedIn
    await tester.runAsync(() async {
      await auth.tapGetStartedButton();
      auth.expectSigninScreen();
      await auth.enterPhoneNumberAndSubmit();
      await auth.expectOtpInputForm();
      final otpCode = await auth.fetchVerificationCode();
      expect(otpCode, isNotNull);
      await auth.enterOtpCodeAndSubmit(otpCode!);
      auth.expectHomeScreen();
      debugPrint('signinSuccess');
    });
  }

  Future<void> addProductAndVerify() async {
    await prod.goToHomeScreen();
    await prod.goToAddProductScreen();
    await prod.createProductAndSubmit();
    await prod.goToProductScreenAndVirifyContent();
  }
}

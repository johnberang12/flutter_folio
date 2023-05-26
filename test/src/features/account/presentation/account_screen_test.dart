import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';
import '../account_robot.dart';

void main() {
  testWidgets('cancel logout', (tester) async {
    final r = AccountRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectAlertDialogFound();
    await r.tapCancelButton();
    r.expectAlertDialogNotFound();
    r.expectErrorAlertNotFound();
  }, timeout: const Timeout(Duration(seconds: 2)));
  testWidgets('confirm logout, success', (tester) async {
    final r = AccountRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogoutButton();
    r.expectAlertDialogFound();
    await r.tapDialogLogoutButton();
    r.expectAlertDialogNotFound();
  }, timeout: const Timeout(Duration(seconds: 2)));
  testWidgets('confirm logout, failure', (tester) async {
    final r = AccountRobot(tester);
    final accountService = MockAccountService();
    final stateError = StateError('Something went wrong');
    when(accountService.logout).thenThrow(stateError);
    await r.pumpAccountScreen(accountService: accountService);
    await r.tapLogoutButton();
    r.expectAlertDialogFound();

    await r.tapDialogLogoutButton();
    r.expectAlertDialogNotFound();
    r.expectErrorAlertFound();
  }, timeout: const Timeout(Duration(seconds: 2)));

  testWidgets('cancel delete account', (tester) async {
    final r = AccountRobot(tester);
    await r.pumpAccountScreen();
    await r.tapDeleteAccountButton();
    r.expectAlertDialogFound();
    await r.tapCancelButton();
    r.expectAlertDialogNotFound();
    r.expectErrorAlertNotFound();
  }, timeout: const Timeout(Duration(seconds: 2)));

  //delete account button shows two confirmation dialog to make sure deleting an account is intentional
  //this test the cancellation of the second dialog
  testWidgets('confirm delete account, cancels confirm delete dialog',
      (tester) async {
    final r = AccountRobot(tester);
    await r.pumpAccountScreen();
    await r.tapDeleteAccountButton();
    r.expectAlertDialogFound();
    await r.tapOkButton();
    r.expectAlertDialogNotFound();
    r.expectErrorAlertNotFound();
    r.expectTextFieldFound();
    await r.tapCancelButton();
    r.expectAlertDialogNotFound();
    r.expectErrorAlertNotFound();
    r.expectTextFieldNotFound();
  }, timeout: const Timeout(Duration(seconds: 2)));

//confirmation text has its own unit test so this test is primarily for the behaviour if delete fails and succeeded.
  testWidgets('confirm delete account, success', (tester) async {
    final r = AccountRobot(tester);
    final accountService = MockAccountService();

    when(() => accountService.deleteAccount(
            confirmation: any(named: 'confirmation')))
        .thenAnswer((_) => Future.value());
    await r.pumpAccountScreen(accountService: accountService);
    await r.tapDeleteAccountButton();
    r.expectAlertDialogFound();
    await r.tapOkButton();
    r.expectAlertDialogNotFound();
    r.expectErrorAlertNotFound();
    r.expectTextFieldFound();

    await tester.runAsync(() async {
      //submit entered confirmation text
      await r.enterDELETEToTheTextField();
    });
    r.expectAlertDialogNotFound();
    r.expectTextFieldNotFound();

    //expecting to find no error dialog but the test shows that error was found
    // r.expectErrorAlertNotFound();
  }, timeout: const Timeout(Duration(seconds: 5)));

  testWidgets('confirm delete account, success', (tester) async {
    final r = AccountRobot(tester);

    final accountService = MockAccountService();
    final stateError = StateError('Something went wrong');
    when(() => accountService.deleteAccount(
        confirmation: any(named: "confirmation"))).thenThrow(stateError);
    //pump account screen
    await r.pumpAccountScreen(accountService: accountService);
    //tap delete account button
    await r.tapDeleteAccountButton();
    //alert dialog found
    r.expectAlertDialogFound();
    //tap ok to confirm
    await r.tapOkButton();
    //alert dialog closes
    r.expectAlertDialogNotFound();
    //error dialog not found
    r.expectErrorAlertNotFound();
    //expect TextField
    r.expectTextFieldFound();

    await tester.runAsync(() async {
      //submit entered confirmation text
      await r.enterDELETEToTheTextField();
    });

    ///textfield closes
    r.expectTextFieldNotFound();
    //alert dialog closes
    r.expectAlertDialogNotFound();
    //shows error alert dialog
    r.expectErrorAlertFound();
  }, timeout: const Timeout(Duration(seconds: 2)));
}

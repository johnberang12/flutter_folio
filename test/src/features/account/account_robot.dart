import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/alert_dialogs.dart';
import 'package:flutter_folio/src/features/account/account_service/account_service.dart';
import 'package:flutter_folio/src/features/account/presentation/account_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

class AccountRobot {
  AccountRobot(this.tester);
  final WidgetTester tester;

  Future<void> pumpAccountScreen({AccountService? accountService}) async {
    await tester.pumpWidget(ProviderScope(
        overrides: [
          if (accountService != null) ...[
            accountServiceProvider.overrideWithValue(MockAccountService())
          ]
        ],
        child: const MaterialApp(
          home: AccountScreen(),
        )));
  }

//****** */Logout button
  Future<void> tapLogoutButton() async {
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
  }

  void expectAlertDialogFound() {
    final dialogTitle = find.text('Alert');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 2000));
  }

  void expectAlertDialogNotFound() {
    final dialogTitle = find.text('Alert');
    expect(dialogTitle, findsNothing);
  }

  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  //****** */Delete account button

  Future<void> tapDeleteAccountButton() async {
    final deleteAccountButton = find.text('Delete account');
    expect(deleteAccountButton, findsOneWidget);
    await tester.tap(deleteAccountButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapOkButton() async {
    final okButton = find.text('Ok');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }

  void expectTextFieldFound() {
    final textField = find.byType(TextFormField);
    expect(textField, findsOneWidget);
  }

  void expectTextFieldNotFound() {
    final textField = find.byType(TextFormField);
    expect(textField, findsNothing);
  }

  Future<void> enterDELETEToTheTextField() async {
    // final textField = find.byType(TextFormField);
    // await tester.enterText(textField, 'DELETE');
    final submitButton = find.text('Submit');
    await tester.tap(submitButton);
    await tester.pumpAndSettle(const Duration(milliseconds: 2000));
  }

  void alertContainsWrongConfirmationText() {
    final text = find.textContaining('Ok');
    expect(text, findsOneWidget);
  }

  // void expectDeleteConfirmationTextFieldFound() {
  //   final confirmDeleteText = find.textContaining('Enter DELETE to confirm:');
  //   expect(confirmDeleteText, findsOneWidget);
  // }

  // void expectDeleteConfirmationTextFieldNotFound() {
  //   final confirmDeleteText = find.textContaining('Enter DELETE to confirm:');
  //   expect(confirmDeleteText, findsNothing);
  // }
}

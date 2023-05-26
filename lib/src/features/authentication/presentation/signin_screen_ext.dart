import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/alert_dialogs.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen.dart';

//* this is created to handle phone verification exception as Firebase sdk designed the exception to be handled manually in the UI

enum AuthException {
  //* can add more exceptions here if necessary.
  invalidPhoneNumber(
      code: "invalid-phone-number",
      title: 'Invalid phone number',
      message:
          'Invalid phone number format. Please enter a valid phone number.'),
  userNotFound(
      code: 'user-not-found',
      title: 'User not found',
      message:
          'No user found for this credential. Please contact our support team at support@muraitamarket.com for assistance.'),
  userDisabled(
      code: 'user-disabled',
      title: 'User disabled',
      message:
          'You were disabled to use this platform. If you think this was a mistake or a bug, please contact us at support@muraitamarket.com.'),
  internalError(
      code: 'internal-error',
      title: 'Internal error',
      message: 'Internal error occured. Please try again later.');

  const AuthException(
      {required this.code, required this.title, required this.message});
  final String code;
  final String title;
  final String message;
}

extension SigninScreenX on SigninScreen {
  String errorTitle(String code) {
    for (var e in AuthException.values) {
      if (e.code == code) {
        return e.title;
      }
    }
    return AuthException.internalError.title;
  }

  String errorMessage(String code) {
    for (var e in AuthException.values) {
      if (e.code == code) {
        return e.message;
      }
    }
    return AuthException.internalError.message;
  }

  void phoneVerificationFailed(FirebaseAuthException e, BuildContext context) {
    debugPrint(
        'phoneVerificationFailed===code:${e.code}, message:${e.message}');
    showExceptionAlertDialog(
        context: context,
        //accepts a code to return title
        title: errorTitle(e.code),
        //accepts a code to return the message
        exception: errorMessage(e.code));
  }
}

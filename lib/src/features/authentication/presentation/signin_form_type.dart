import 'package:flutter/material.dart';
import 'package:flutter_folio/src/features/authentication/presentation/pinput.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_with_phone_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/sizes.dart';
import 'phone_number_input_field.dart';

enum SigninFormType { phoneNumber, otpCode }

extension SigninFormTypeX on SigninFormType {
  String get signinButtonText {
    if (this == SigninFormType.phoneNumber) {
      return "Verify phone number";
    } else {
      return "Verify sms code";
    }
  }

  // phone number: +635551234567
  // otp code: 123456

  String get signinFormHeaderText {
    if (this == SigninFormType.phoneNumber) {
      return 'Please enter your valid phone number';
    } else {
      return 'Please enter the sms code sent to your phone number';
    }
  }

  Widget signinInputForm({
    required TextEditingController numberController,
    required TextEditingController otpController,
    required FocusNode focusNode,
    void Function(String)? onNumberChange,
    // required void Function(String) verifyPhoneNumber,
    required Function(String) onOtpComplete,
  }) {
    return this == SigninFormType.phoneNumber
        ? PhoneNumberInputField(
            focusNode: focusNode,
            controller: numberController,
            onchanged: onNumberChange,
            // onEditingComplete: verifyPhoneNumber,
          )
        : CustomPinPutWidget(
            otpController: otpController,
            onSubmitOtp: onOtpComplete,
          );
  }

  List<Widget> resendButton(void Function() resendCode) {
    return [
      if (this == SigninFormType.otpCode) ...[
        ResendButton(onSubmit: resendCode),
        gapH12,
      ]
    ];
  }

  Future<void> onPrimaryButtonPress({
    required Future<void> Function() verifyPhoneNumber,
    required Future<void> Function() verifyOtpCode,
  }) async {
    if (this == SigninFormType.phoneNumber) {
      debugPrint('verifying phone number');
      await verifyPhoneNumber();
    } else {
      debugPrint('calling verifyOtpCode...');
      await verifyOtpCode();
    }
  }
}

final signinFormTypeProvider = StateProvider.autoDispose<SigninFormType>(
    (ref) => SigninFormType.phoneNumber);

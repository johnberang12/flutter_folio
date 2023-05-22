import 'package:flutter_folio/src/features/authentication/presentation/string_validator.dart';

mixin SigninValidator {
  final StringValidator numberValidator = PhoneNumberEditingRegexValidator();
  final StringValidator otpValidator = OtpInputValidator();

  bool canSubmitNumber(String number) {
    return numberValidator.isValid(number);
  }

  bool canSubmitOtp(String otp) {
    return otpValidator.isValid(otp);
  }

  String? numberErrorText(String? number) {
    final bool showErrorText = !canSubmitNumber(number ?? '');
    const String errorText = "Invalid phone number format";
    return showErrorText ? errorText : null;
  }

  String? otpErrorText(String otp) {
    final bool showErrorText = !canSubmitOtp(otp);
    const String errorText = "Invalid code";
    return showErrorText ? errorText : null;
  }
}

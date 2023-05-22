enum SigninFormType { phoneNumber, otpCode }

extension SigninFormTypeX on SigninFormType {
  String get signinButtonText {
    if (this == SigninFormType.phoneNumber) {
      return "Verify phone number";
    } else {
      return "Verify sms code";
    }
  }

  String get signinMessageGuide {
    if (this == SigninFormType.phoneNumber) {
      return 'Enter this phone number: +635551234567';
    } else {
      return "Your sms code is 123456";
    }
  }
}

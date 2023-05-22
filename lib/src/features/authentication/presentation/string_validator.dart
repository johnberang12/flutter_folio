abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({required this.regexSource});
  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

// class ValidatorInputFormatter implements TextInputFormatter {
//   ValidatorInputFormatter({required this.editingValidator});
//   final StringValidator editingValidator;

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     final bool oldValueValid = editingValidator.isValid(oldValue.text);
//     final bool newValueValid = editingValidator.isValid(newValue.text);
//     if (oldValueValid && !newValueValid) {
//       return oldValue;
//     }
//     return newValue;
//   }
// }

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class PhoneNumberEditingRegexValidator extends RegexValidator
    with StringValidator {
  PhoneNumberEditingRegexValidator() : super(regexSource: r'^[0-9]{10}$');
}

class OtpInputValidator extends RegexValidator with StringValidator {
  OtpInputValidator() : super(regexSource: r'^[0-9]{6}$');
}

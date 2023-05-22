import '../../../authentication/presentation/string_validator.dart';

mixin AddProductScreenValidator {
  final StringValidator stringValidator = NonEmptyStringValidator();
  bool canSubmitTitle(String title) {
    return stringValidator.isValid(title);
  }

  bool canSubmitPrice(String price) {
    return stringValidator.isValid(price);
  }

  bool canSubmitDescription(String description) {
    return stringValidator.isValid(description);
  }

  String? imageErrorText(int imageCount) {
    final bool showErrorText = imageCount < 1;
    const String errorText = 'Image can\'t be empty';
    return showErrorText ? errorText : null;
  }

  String? titleErrorText(String? value) {
    final title = value ?? '';
    final bool showErrorText = !canSubmitTitle(title);
    final String errorText =
        title.isEmpty ? 'Title can\'t be empty' : 'Invalid title';
    return showErrorText ? errorText : null;
  }

  String? priceErrorText(String? value) {
    final price = value ?? '';
    final bool showErrorText = !canSubmitPrice(price);
    final String errorText =
        price.isEmpty ? 'Price can\'t be empty' : 'Invalid price';
    return showErrorText ? errorText : null;
  }

  String? descriptionErrorText(String? value) {
    final description = value ?? '';
    final bool showErrorText = !canSubmitDescription(description);
    final String errorText = description.isEmpty
        ? 'Description can\'t be empty'
        : 'Invalid description';
    return showErrorText ? errorText : null;
  }
}

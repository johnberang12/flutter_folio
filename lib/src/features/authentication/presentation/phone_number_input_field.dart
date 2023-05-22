import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widget/outlined_text_field.dart';
import '../../../utils/country_code_picker.dart';
import 'pinput.dart';
import 'signin_form_type.dart';

class SignInNumberInputField extends StatelessWidget {
  const SignInNumberInputField({
    super.key,
    required this.formType,
    required this.verifyPhoneNumber,
    required this.submitOTP,
    required this.numberController,
    required this.otpController,
    required this.focusNode,
  });
  final ValueNotifier<SigninFormType> formType;
  final void Function(String) verifyPhoneNumber;
  final Future<void> Function(String) submitOTP;
  final TextEditingController numberController;
  final TextEditingController otpController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return formType.value == SigninFormType.otpCode
        ? CustomPinPutWidget(
            onSubmitOtp: submitOTP, otpController: otpController)
        : PhoneNumberInputField(
            focusNode: focusNode,
            controller: numberController,
            onEditingComplete: verifyPhoneNumber,
          );
  }
}

class PhoneNumberInputField extends ConsumerWidget with SigninValidator {
  PhoneNumberInputField({
    super.key,
    required this.focusNode,
    required this.controller,
    this.onchange,
    this.onEditingComplete,
    this.validator,
  });
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(String)? onchange;
  final void Function(String)? onEditingComplete;

  final String? Function(String?)? validator;

  void _onTap() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    } else {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryCode = ref.read(countryCodeProvider);
    final phoneNumber = "+$countryCode${controller.text}}";
    return OutlinedTextField(
      focusNode: focusNode,
      onTap: _onTap,
      prefix: _countryCodeWidget(context: context, ref: ref),
      controller: controller,
      autofocus: true,
      labelText: "Phone number",
      hintText: '915*******',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: numberErrorText,
      textInputAction: TextInputAction.send,
      keyboardType: TextInputType.number,
      onChange: onchange,
      onEditingComplete: onEditingComplete != null
          ? () => onEditingComplete!(phoneNumber)
          : null,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
      ],
      maxLength: 10,
    );
  }

  Widget _countryCodeWidget({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final countryCode = ref.watch(countryCodeProvider);
    final countryFlag = ref.watch(countryFlagProvider);
    return TextButton(
      onPressed: () => pickCountryCode(
          context: context,
          onSelect: (country) {
            ref
                .read(countryCodeProvider.notifier)
                .update((_) => country.phoneCode);
            ref
                .read(countryFlagProvider.notifier)
                .update((_) => country.flagEmoji);
          }),
      child: Text('$countryFlag +$countryCode',
          style: const TextStyle(fontSize: 16)),
    );
  }
}

//*providers used to store the country code and country flag and handle updating the UI when changes is made.
final countryCodeProvider = StateProvider.autoDispose<String>((ref) => '63');
final countryFlagProvider = StateProvider.autoDispose<String>((ref) => '🇵🇭');

import 'package:flutter/material.dart';
import 'package:flutter_folio/src/constants/sizes.dart';
import 'package:flutter_folio/src/features/authentication/presentation/phone_number_input_field.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen_controller.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen_ext.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_with_phone_button.dart';
import 'package:flutter_folio/src/utils/async_value_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/styles.dart';
import 'signin_form_type.dart';

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///signinScreenController listener that triggers alert dialog when something went wrong
    ref.listen<AsyncValue>(signinScreenControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));
    final formType = ref.watch(signinFormTypeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              formType.signinFormHeaderText,
              style: Styles.k18(context),
            ),
            gapH64,
            const SigninForm(),
          ],
        ),
      )),
    );
  }

  void switchFormType(ValueNotifier<SigninFormType> formType) {
    if (formType.value == SigninFormType.phoneNumber) {
      formType.value = SigninFormType.otpCode;
    } else {
      formType.value = SigninFormType.phoneNumber;
    }
  }
}

class SigninForm extends HookConsumerWidget {
  const SigninForm({super.key});
  //* cetralized function to trigger either verifyPhoneNumber or verifyOtpCode
  Future<void> _onPrimaryButtonPress(
      {required WidgetRef ref,
      required BuildContext context,
      required TextEditingController numberController,
      required String otpCode,
      required ValueNotifier<String> verificationID}) async {
    final controller = ref.read(signinScreenControllerProvider.notifier);
    //* this checks the form type to know which method to call in the controller

    await ref.read(signinFormTypeProvider).onPrimaryButtonPress(
        verifyPhoneNumber: () => _verifyPhoneNumber(
            context: context,
            ref: ref,
            numberController: numberController,
            verificationID: verificationID),
        verifyOtpCode: () => controller.verifyOtpCode(
            otpCode: otpCode, verificationId: verificationID.value));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberController = useTextEditingController(text: '');
    final otpController = useTextEditingController(text: '');
    final verificationId = useState<String>('');
    final formType = ref.watch(signinFormTypeProvider);

    final focuseNode = useFocusNode();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        formType.signinInputForm(
            onOtpComplete: (otpCode) => _verifyOtpCode(
                ref: ref,
                otpCode: otpCode,
                verificationId: verificationId.value),
            numberController: numberController,
            otpController: otpController,
            focusNode: focuseNode),
        gapH32,
        SignInWithPhoneButton(
            onPrimaryButtonPress: () => _onPrimaryButtonPress(
                context: context,
                ref: ref,
                numberController: numberController,
                otpCode: otpController.text,
                verificationID: verificationId),
            controller: numberController,
            resendCode: () => _verifyPhoneNumber(
                context: context,
                ref: ref,
                numberController: numberController,
                verificationID: verificationId)),
      ],
    );
  }

  Future<void> _verifyPhoneNumber(
      {required BuildContext context,
      required WidgetRef ref,
      required TextEditingController numberController,
      required ValueNotifier<String> verificationID}) async {
    final countryCode = ref.read(countryCodeProvider);
    final phoneNumber = "+$countryCode${numberController.text}";

    await ref.read(signinScreenControllerProvider.notifier).verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationFailed: (e) => phoneVerificationFailed(e, context),
        codeSent: (verificationId, token) {
          //*This method is called when the code is successfully sent to the user
          //* it saves the verification id to a variable to be used for verification and switch the formtype to otpCode form
          debugPrint('code sent...');
          verificationID.value = verificationId ?? "";

          ref
              .read(signinFormTypeProvider.notifier)
              .update((state) => SigninFormType.otpCode);
        });
  }

  Future<void> _verifyOtpCode(
          {required WidgetRef ref,
          required String otpCode,
          required String verificationId}) =>
      ref
          .read(signinScreenControllerProvider.notifier)
          .verifyOtpCode(otpCode: otpCode, verificationId: verificationId);
}

import 'package:flutter/material.dart';
import 'package:flutter_folio/src/constants/sizes.dart';
import 'package:flutter_folio/src/features/authentication/presentation/phone_number_input_field.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen_controller.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen_ext.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_with_phone_button.dart';
import 'package:flutter_folio/src/utils/async_value_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/styles.dart';
import 'signin_form_type.dart';

class SigninScreen extends HookWidget {
  const SigninScreen({super.key});

//* cetralized function to trigger either verifyPhoneNumber or verifyOtpCode
  Future<void> _onPrimaryButtonPress(
      {required WidgetRef ref,
      required BuildContext context,
      required ValueNotifier<SigninFormType> formType,
      required String number,
      required String otpCode,
      required ValueNotifier<String> verificationID}) async {
    //* this checks the form type to know which method to call in the controller
    if (formType.value == SigninFormType.phoneNumber) {
      debugPrint('phoneNumber: $number');
      await ref.read(signinScreenControllerProvider.notifier).verifyPhoneNumber(
          phoneNumber: number,
          verificationFailed: (e) => phoneVerificationFailed(e, context),
          codeSent: (verificationId, token) {
            //*This method is called when the code is successfully sent to the user
            //* it saves the verification id to a variable to be used for verification and switch the formtype to otpCode form
            debugPrint('code sent...');
            verificationID.value = verificationId ?? "";
            formType.value = SigninFormType.otpCode;
          });
    } else {
      debugPrint('calling verifyOtpCode...');
      ref.read(signinScreenControllerProvider.notifier).verifyOtpCode(
          otpCode: otpCode, verificationId: verificationID.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberController = useTextEditingController(text: '');
    final otpController = useTextEditingController(text: '');
    final verificationId = useState<String>('');
    final formType = useState<SigninFormType>(SigninFormType.phoneNumber);

    final focuseNode = useFocusNode();
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
              formType.value.signinMessageGuide,
              style: Styles.k18(context),
            ),
            gapH64,
            Consumer(builder: (context, ref, _) {
              ///signinScreenController listener that triggers alert dialog when something went wrong
              ref.listen<AsyncValue>(signinScreenControllerProvider,
                  (_, state) => state.showAlertDialogOnError(context));

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInNumberInputField(
                      verifyPhoneNumber: (phoneNumber) => _onPrimaryButtonPress(
                          context: context,
                          ref: ref,
                          formType: formType,
                          number: numberController.text,
                          otpCode: otpController.text,
                          verificationID: verificationId),
                      submitOTP: (otpCode) => _onPrimaryButtonPress(
                          context: context,
                          ref: ref,
                          formType: formType,
                          number: numberController.text,
                          otpCode: otpCode,
                          verificationID: verificationId),
                      formType: formType,
                      numberController: numberController,
                      otpController: otpController,
                      focusNode: focuseNode),
                  gapH32,
                  SignInWithPhoneButton(
                      formType: formType,
                      onPrimaryButtonPress: (formType, phoneNumber) =>
                          _onPrimaryButtonPress(
                              context: context,
                              ref: ref,
                              formType: formType,
                              number: phoneNumber,
                              otpCode: otpController.text,
                              verificationID: verificationId),
                      controller: numberController,
                      resendCode: () =>
                          formType.value = SigninFormType.phoneNumber),

                  ///* romove this after testing
                  // gapH64,
                  // TextButton(
                  //     onPressed: () => switchFormType(formType),
                  //     child: const Text('Switch form'))
                ],
              );
            }),
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

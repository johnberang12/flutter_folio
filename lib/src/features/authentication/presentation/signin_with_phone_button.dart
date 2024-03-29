import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen_controller.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_validators.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widget/primary_button.dart';
import '../../../constants/styles.dart';
import 'signin_form_type.dart';

const kPhoneSigninButtonKey = Key('phone-signin-button-key');

class SignInWithPhoneButton extends HookConsumerWidget with SigninValidator {
  SignInWithPhoneButton(
      {super.key,
      required this.onPrimaryButtonPress,
      required this.controller,
      required this.resendCode});

  final Future<void> Function() onPrimaryButtonPress;
  final void Function() resendCode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSubmit = useState<bool>(false);
    void handleTextChanged() {
      canSubmit.value = canSubmitNumber(controller.text);
    }

    useEffect(() {
      controller.addListener(handleTextChanged);
      return () => controller.removeListener(handleTextChanged);
    }, [controller]);
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(signinScreenControllerProvider);
      final formType = ref.watch(signinFormTypeProvider);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...formType.resendButton(resendCode),
          PrimaryButton(
            key: kPhoneSigninButtonKey,
            loading: state.isLoading,
            width: double.infinity,
            onPressed: !canSubmit.value ? null : () => onPrimaryButtonPress(),
            child: Text(formType.signinButtonText,
                style: Styles.k16(context).copyWith(color: Colors.white)),
          )
        ],
      );
    });
  }
}

class ResendButton extends HookWidget {
  const ResendButton({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final timer = useState<Timer?>(null);
    final seconds = useState(120);

    useEffect(() {
      timer.value?.cancel();
      timer.value = Timer.periodic(const Duration(milliseconds: 1000), (_) {
        seconds.value = seconds.value - 1;
        if (seconds.value <= 0) {
          timer.value?.cancel();
        }
      });

      return () {
        timer.value?.cancel();
      };
    }, []);

    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer(builder: (_, ref, __) {
          final state = ref.watch(signinScreenControllerProvider);

          return PrimaryButton(
            onPressed: seconds.value < 1 && !state.isLoading ? onSubmit : null,
            loading: state.isLoading,
            width: double.infinity,
            child: Center(
              child: Text(
                seconds.value < 1
                    ? 'Resend code'
                    : 'Resend code after ${seconds.value} secs.',
                style: Styles.k16Bold(context).copyWith(color: Colors.white),
              ),
            ),
          );
        }),
        SizedBox(height: height * 0.025),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class EditProductDialogContent extends ConsumerWidget {
  const EditProductDialogContent(
      {super.key,
      required this.initialValue,
      required this.title,
      required this.fieldValue,
      this.confirmText,
      this.onConfirm});
  final String initialValue;
  final String title;
  final VoidCallback? onConfirm;
  final String? confirmText;
  final String fieldValue;

  // final textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(editBottomSheetTextProvider(initialValue));

    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double radius = Platform.isIOS ? 40 : 20;
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: height * .50 * textScaleFactor,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(radius),
                  bottom: Radius.circular(radius))),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              reverse: true,
              shrinkWrap: true,
              children: <Widget>[
                gapH16,
                Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColors.black60(context),
                  size: 48,
                ),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: 'We\'re sorry to see you go!',
                        style: Styles.k14Bold(context)),
                    const TextSpan(
                        text:
                            '\n\nJust a friendly reminder that deleting your account is a permanent action and all of your data will be lost. If you\'re having second thoughts, feel free to come back anytime. We\'ll be here.')
                  ]),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '$fieldValue: ',
                          style: Styles.k14Bold(context)),
                      TextSpan(
                        text: text,
                        style: Styles.k14(context),
                      )
                    ]),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        inputFormatters: null,
                        keyboardType: TextInputType.text,
                        initialValue: text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.black20(context),
                          border: InputBorder.none,
                          hintText: 'Enter text',
                        ),
                        onChanged: (value) => ref
                            .read(editBottomSheetTextProvider(initialValue)
                                .notifier)
                            .state = value,
                        enableSuggestions: false,
                        maxLines: 4,
                        minLines: 1,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                DialogFooter(
                  onConfirm: onConfirm,
                  confirmText: confirmText,
                ),
              ].reversed.toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogFooter extends StatelessWidget {
  const DialogFooter(
      {super.key,
      this.onConfirm,
      this.onCancel,
      this.cancelText,
      this.confirmText,
      this.cancelStyle,
      this.confirmStyle});
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String? cancelText;
  final String? confirmText;
  final TextStyle? cancelStyle;
  final TextStyle? confirmStyle;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(false),
              child: Text(
                cancelText ?? 'Cancel',
                style: cancelStyle ?? kDialogCancelStyle(context),
              )),
          const VerticalDivider(),
          TextButton(
              onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
              child: Text(confirmText ?? 'Submit',
                  style: confirmStyle ?? kDialogConfirmStyle(context))),
        ],
      ),
    );
  }
}

final editBottomSheetTextProvider = StateProvider.autoDispose
    .family<String, String>((ref, initialValue) => initialValue);

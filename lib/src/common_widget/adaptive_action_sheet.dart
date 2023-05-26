import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';

const kCancelActionKey = Key('cancel-action-button-text');

Future<void> showAppActionSheet(
    {required BuildContext context,
    required Widget title,
    required Widget firstActionTitle,
    required Future<void> Function() firstActionOnPressed,
    required Widget secondActionTitle,
    required Future<void> Function() secondActionOnPressed,
    Widget? thirdActionTitle,
    Future<void> Function()? thirdActionOnPressed,
    CancelAction? cancelAction,
    bool isDismissible = false}) async {
  return showAdaptiveActionSheet(
      isDismissible: isDismissible,
      context: context,
      actions: [
        BottomSheetAction(
          title: title,
          onPressed: (_) {},
        ),
        BottomSheetAction(
            title: firstActionTitle,
            onPressed: (context) => Navigator.of(context,
                    rootNavigator: Platform.isIOS ? true : false)
                .pop(firstActionOnPressed())),
        BottomSheetAction(
            title: secondActionTitle,
            onPressed: (context) => Navigator.of(context,
                    rootNavigator: Platform.isIOS ? true : false)
                .pop(secondActionOnPressed())),
        if (thirdActionTitle != null && thirdActionOnPressed != null) ...[
          BottomSheetAction(
            title: thirdActionTitle,
            onPressed: (context) => Navigator.of(context,
                    rootNavigator: Platform.isIOS ? true : false)
                .pop(thirdActionOnPressed()),
          ),
        ]
      ],
      cancelAction: cancelAction ??
          CancelAction(
              title: const Text(
            'Cancel',
            key: kCancelActionKey,
          )));
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'alert_dialogs.dart';

//this confirmation callback is used to wrap a
// function that needs a confirmation before performing an operation
Future<void> confirmationCallback({
  required BuildContext context,
  required String content,
  required FutureOr<void> Function() callback,
  String defaultActionText = "Ok",
  String cancelActionText = "Cancel",
  String? title,
  TextAlign contentAlignment = TextAlign.start,
  TextStyle? contentStyle,
}) async {
  await Future.delayed(const Duration(milliseconds: 5), () async {
    final confirm = await showAlertDialog(
      context: context,
      title: title ?? "Alert",
      content: content,
      defaultActionText: defaultActionText,
      cancelActionText: cancelActionText,
      contentAlignment: contentAlignment,
      contentStyle: contentStyle,
    );
    if (confirm == true) {
      await callback();
    }
  });
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../features/account/presentation/delete_account_dialog_content.dart';

const kDialogDefaultKey = Key('dialog-default-key');

enum EditDialogType { editField, deleteAccount }

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog(
    {required BuildContext context,
    required String title,
    String? content,
    Widget? widgetContent,
    String? cancelActionText,
    String defaultActionText = 'OK',
    TextStyle? contentStyle,
    TextAlign contentAlignment = TextAlign.start}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      barrierDismissible: cancelActionText != null,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: widgetContent ??
            Text(
              content ?? "",
              textAlign: contentAlignment,
              style: contentStyle,
            ),
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText,
                  style: const TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            key: kDialogDefaultKey,
            child: Text(defaultActionText,
                style: const TextStyle(color: Colors.green)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    barrierDismissible: cancelActionText != null,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content:
          widgetContent ?? Text(content ?? "", textAlign: contentAlignment),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText,
                style: const TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          key: kDialogDefaultKey,
          child: Text(
            defaultActionText,
            style: TextStyle(color: AppColors.blue(context)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: "Ok",
    );

Future<void> showUnimplementedAlertDialog({required BuildContext context}) =>
    showAlertDialog(
      context: context,
      title: "Unimplemented",
    );

Future<void> showCallbackDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
  VoidCallback? onCancel,
  VoidCallback? onProceed,
}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      barrierDismissible: cancelActionText != null,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(false),
              child: Text(cancelActionText,
                  style: const TextStyle(color: Colors.red)),
            ),
          TextButton(
            key: kDialogDefaultKey,
            onPressed: onProceed ?? () => Navigator.of(context).pop(true),
            child: Text(defaultActionText,
                style: const TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    barrierDismissible: cancelActionText != null,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            onPressed: onCancel ?? () => Navigator.of(context).pop(false),
            child: Text(cancelActionText,
                style: const TextStyle(color: Colors.red)),
          ),
        CupertinoDialogAction(
          key: kDialogDefaultKey,
          onPressed: onProceed ?? () => Navigator.of(context).pop(true),
          child: Text(
            defaultActionText,
            style: TextStyle(color: AppColors.blue(context)),
          ),
        ),
      ],
    ),
  );
}

Future<bool?> showEditBottomSheet({
  required BuildContext context,
  required String fieldValue,
  required String initialValue,
  required String title,
  EditDialogType dialogType = EditDialogType.editField,
  String? confirmText,
}) async {
  final double radius = Platform.isIOS ? 40 : 20;
  final submit = await showModalBottomSheet<bool?>(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radius))),
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: ((context) => EditProductDialogContent(
            fieldValue: fieldValue,
            confirmText: confirmText,
            initialValue: initialValue,
            title: title,
          )));

  if (submit == true) {
    return true;
  } else {
    return false;
  }
}

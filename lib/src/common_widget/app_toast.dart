import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ToastService {
  void showToast({
    required String msg,
    bool longToast,
    double? fontSize,
    ToastGravity? gravity,
    Color backgroundColor,
    Color? textColor,
  });
}

class AppToast implements ToastService {
  @override
  void showToast({
    required String msg,
    bool longToast = true,
    double? fontSize,
    ToastGravity? gravity,
    Color backgroundColor = Colors.blueAccent,
    Color? textColor,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: longToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      fontSize: fontSize,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}

final appToastProvider = Provider<AppToast>((ref) => AppToast());

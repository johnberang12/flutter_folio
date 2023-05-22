import 'package:flutter/material.dart';
import '../constants/sizes.dart';

/// Text button to be used as an [AppBar] action
class AppbarActionTextButton extends StatelessWidget {
  const AppbarActionTextButton(
      {super.key,
      required this.text,
      this.onPressed,
      this.textColor,
      required this.isLoading,
      this.fontSize});
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double? fontSize;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p18),
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize ?? 18, color: textColor),
        ),
      ),
    );
  }
}

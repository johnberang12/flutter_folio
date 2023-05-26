import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/styles.dart';

class ClearTextField extends StatelessWidget {
  const ClearTextField(
      {Key? key,
      this.textFieldKey,
      this.controller,
      this.label,
      this.width = double.infinity,
      this.keyboardType,
      this.autovalidateMode,
      this.validator,
      this.inputFormatters,
      this.initialValue,
      this.onChanged,
      this.style,
      this.minLines,
      this.maxLines})
      : super(key: key);

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final double? width;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final TextStyle? style;
  final int? maxLines;
  final int? minLines;
  final Key? textFieldKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        key: textFieldKey,
        initialValue: initialValue,
        inputFormatters: inputFormatters,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
          label: Text(
            label ?? '',
            style: Styles.k16Grey(context),
          ),
        ),
        style: style,
        autovalidateMode: autovalidateMode,
        validator: validator,
        autocorrect: false,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}

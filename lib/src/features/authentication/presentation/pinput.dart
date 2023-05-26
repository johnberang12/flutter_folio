import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_colors.dart';

class CustomPinPutWidget extends StatefulWidget {
  const CustomPinPutWidget({
    Key? key,
    required this.onSubmitOtp,
    required this.otpController,
  }) : super(key: key);
  final ValueChanged<String> onSubmitOtp;
  final TextEditingController otpController;

  @override
  State<CustomPinPutWidget> createState() => _CustomPinPutWidgetState();
}

class _CustomPinPutWidgetState extends State<CustomPinPutWidget> {
  List<FocusNode> _focusNodes = [];
  List<TextEditingController> _controllers = [];
  final int _pinLength = 6;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_pinLength, (index) => FocusNode());
    _controllers = List.generate(_pinLength, (index) {
      final controller = TextEditingController();
      controller.addListener(() => _onControllerChange(index, controller));
      return controller;
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: RawKeyboardListener(
        focusNode: FocusNode(canRequestFocus: false),
        onKey: (event) {
          int? currentIndex =
              _focusNodes.indexWhere((node) => node.hasPrimaryFocus);
          if (currentIndex == -1) return;

          if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
            if (_controllers[currentIndex].text.isEmpty && currentIndex > 0) {
              _focusNodes[currentIndex].unfocus();
              _focusNodes[currentIndex - 1].requestFocus();
              _controllers[currentIndex - 1].clear();
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_pinLength, (index) {
            return SizedBox(
              width: 56,
              height: 90,
              child: TextField(
                key: ValueKey(index),
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                autofocus: index == 0,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  isDense: true,
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.black60(context)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.black60(context)),
                  ),
                  filled: true,
                  fillColor: AppColors.black20(context),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _onControllerChange(int index, TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      if (index == _pinLength - 1) {
        _submitOtp();
      } else {
        _focusNodes[index].unfocus();
        _focusNodes[index + 1].requestFocus();
      }
    }
  }

  void _submitOtp() {
    String otp = _controllers.map((controller) => controller.text).join();
    widget.onSubmitOtp(otp);
  }
}

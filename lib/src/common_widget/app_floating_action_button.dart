import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/sizes.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton(
      {Key? key,
      required this.onPressed,
      this.loadingDuration = 2000,
      this.loaderColor})
      : super(key: key);

  final VoidCallback? onPressed;
  final int loadingDuration;
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p64),
      child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: AppColors.primaryHue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}

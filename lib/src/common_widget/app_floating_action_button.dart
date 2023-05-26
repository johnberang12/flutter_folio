import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/sizes.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    Key? key,
    required this.onPressed,
    this.appFABKey,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Key? appFABKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.p64),
      child: FloatingActionButton(
          key: appFABKey,
          onPressed: onPressed,
          backgroundColor: AppColors.primaryHue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}

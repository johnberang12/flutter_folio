import 'package:flutter/material.dart';

import '../../../constants/styles.dart';

class CameraActionTitle extends StatelessWidget {
  const CameraActionTitle({super.key, required this.lable, required this.icon});
  final String lable;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Icon(
            icon,
            size: 26,
          ),
        ),
        Expanded(
          child: Text(
            lable,
            style: Styles.k18(context),
          ),
        ),
        Expanded(
          child: Opacity(
              opacity: 0.0,
              child: Icon(
                icon,
                size: 26,
              )),
        ),
      ],
    );
  }
}

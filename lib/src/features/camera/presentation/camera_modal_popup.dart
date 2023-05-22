import 'package:flutter/material.dart';

import '../../../common_widget/adaptive_action_sheet.dart';
import '../../../constants/styles.dart';
import 'camera_action_title.dart';

Future<void> showCameraActionSheet(
    {required BuildContext context,
    required Future<void> Function() pickMultipleImages,
    required Future<void> Function() pickSingleImage,
    required Future<void> Function() openDeviceCamera,
    bool allowMultiple = false,
    int imageLimit = 10}) async {
  return showAppActionSheet(
      context: context,
      title: Text(
        'Choose image source',
        style: Styles.k16Bold(context).copyWith(color: Colors.amber),
      ),
      firstActionTitle: const CameraActionTitle(
          lable: 'Camera', icon: Icons.camera_alt_outlined),
      firstActionOnPressed: openDeviceCamera,
      secondActionTitle:
          const CameraActionTitle(lable: 'Gallery', icon: Icons.image_outlined),
      secondActionOnPressed:
          allowMultiple ? pickMultipleImages : pickSingleImage);
}

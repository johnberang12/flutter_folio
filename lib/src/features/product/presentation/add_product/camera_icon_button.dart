import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/app_loader.dart';
import 'package:flutter_folio/src/utils/async_value_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common_widget/image_editing_controller.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../services/permission_handler_service.dart';
import '../../../camera/presentation/camera_modal_popup.dart';
import '../../../camera/presentation/access_denied_dialog.dart';
import 'camera_icon_button_controller.dart';

const kCameraIconButtonKey = Key('camera-icon-button-key');

class CameraIconButton extends HookConsumerWidget {
  const CameraIconButton({
    Key? key,
    required this.height,
    required this.width,
    required this.fileController,
    required this.networkController,
  }) : super(key: key);
  final double height;
  final double width;
  final ImageEditingController<File> fileController;
  final ImageEditingController<String> networkController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //a listener the listens to possible error/exceptions which taking a pickture and show a the error to a dialog
    ref.listen(cameraIconButtonControllerProvider,
        (_, state) => state.showAlertDialogOnError(context));
    final pickImageController =
        ref.watch(cameraIconButtonControllerProvider.notifier);
//calculates the total images taken plus the network images if available
    final totalImages = fileController.length + networkController.length;
    final mounted = useIsMounted();
    final state = ref.watch(cameraButtonControllerProvider);
    return InkWell(
      key: kCameraIconButtonKey,
      onTap: () => showCameraActionSheet(
          context: context,
          pickMultipleImages: () => ref
              .read(cameraButtonControllerProvider.notifier)
              .pickGalleryImages(
                  mounted: mounted,
                  fileController: fileController,
                  deniedPermission: () => showAccessPermissionDeniedDialog(
                        context: context,
                        permissionType: PermissionType.photos,
                      ),
                  totalImages: totalImages),
          pickSingleImage: () async {},
          openDeviceCamera: () => pickImageController.openDeviceCamera(
              fileController: fileController,
              deniedPermission: () => showAccessPermissionDeniedDialog(
                    context: context,
                    permissionType: PermissionType.camera,
                  ),
              totalImages: totalImages),
          allowMultiple: true),
      highlightColor: AppColors.primaryHue,
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: AppColors.containerColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.black)),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: state.isLoading
                ? AppLoader.circularProgress()
                : Icon(
                    Icons.camera_alt_outlined,
                    size: Sizes.p28,
                    color: AppColors.black60(context),
                  ),
          )),
    );
  }
}

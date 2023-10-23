import 'dart:io';

import 'package:flutter_folio/src/features/camera/application/pick_image_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../common_widget/image_editing_controller.dart';
part 'camera_icon_button_controller.g.dart';

class CameraIconButtonController extends StateNotifier<AsyncValue<void>> {
  CameraIconButtonController({required this.service})
      : super(const AsyncData(null));
  final PickImageService service;

  Future<void> openDeviceCamera({
    required ImageEditingController<File> fileController,
    required Future<void> Function() deniedPermission,
    required int totalImages,
  }) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => service.takeCameraImage(
        deniedPermission: deniedPermission,
        fileController: fileController,
        allowMultiple: true,
        totalImages: totalImages));

    if (mounted) {
      state = newState;
    }
  }

  Future<void> pickGalleryImages({
    required ImageEditingController<File> fileController,
    required Future<void> Function() deniedPermission,
    required int totalImages,
  }) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => service.pickMultiImage(
        deniedPermission: deniedPermission,
        fileController: fileController,
        totalImages: totalImages));
    if (mounted) {
      state = newState;
    }
  }
}

final cameraIconButtonControllerProvider =
    StateNotifierProvider<CameraIconButtonController, AsyncValue<void>>((ref) =>
        CameraIconButtonController(
            service: ref.watch(pickImageServiceProvider)));

//* an example of how to use async notifier class with hook's mounted property
//to be able to check whether the widget listening to this sub class is mounted
//before assigning the state.

//take note that we have achieved the above's priciple using
// riverpod async subclass and Hook's useIsMounted hook/callback

@riverpod
class CameraButtonController extends _$CameraButtonController {
  @override
  FutureOr<void> build() {}

  Future<void> pickGalleryImages({
    required ImageEditingController<File> fileController,
    required Future<void> Function() deniedPermission,
    required bool Function() mounted,
    required int totalImages,
  }) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => ref
        .read(pickImageServiceProvider)
        .pickMultiImage(
            deniedPermission: deniedPermission,
            fileController: fileController,
            totalImages: totalImages));
    if (mounted()) {
      state = newState;
    }
  }
}

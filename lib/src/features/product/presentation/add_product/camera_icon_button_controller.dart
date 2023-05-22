import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widget/image_editing_controller.dart';
import '../../../camera/application/pick_image_service.dart';

class CameraIconButtonController extends StateNotifier<AsyncValue<void>> {
  CameraIconButtonController({required this.service})
      : super(const AsyncData(null));
  final PickImageService service;

  Future<void> openDeviceCamera({
    required BuildContext context,
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
    required BuildContext context,
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

final cameraIconButtonControllerProvider = StateNotifierProvider.autoDispose<
        CameraIconButtonController, AsyncValue<void>>(
    (ref) => CameraIconButtonController(
        service: ref.watch(pickImageServiceProvider)));

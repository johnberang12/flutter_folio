// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_folio/src/services/image_picker_service.dart';
import 'package:flutter_folio/src/services/permission_handler_service.dart';

part 'image_picker_repository.g.dart';

// a repository that holds the image picking functions.
//This holds the logic of checking camera/photos permission and request permission
//It fires a callback that the user needs to allow camera permission if the user has previously not granted the permission
//* unit test done
class ImagePickerRepository {
  ImagePickerRepository({
    required this.permissionHandler,
    required this.picker,
  });
  final PermissionHandlerService permissionHandler;
  final ImagePickerService picker;

  Future<File?> pickImage(
      {required ImageSource source,
      double maxHeight = 1500,
      double maxWidth = 1500,
      int imageQuality = 90,
      required Future<void> Function() deniedPermission}) async {
    PermissionType permissionType = source == ImageSource.camera
        ? PermissionType.camera
        : PermissionType.photos;
    PermissionStatus status =
        await permissionHandler.requestPermission(permissionType);
    if (status == PermissionStatus.granted) {
      final image = await picker.pickImage(
        source: source,
        maxHeight: maxHeight,
        maxWidth: maxHeight,
        imageQuality: imageQuality,
      );

      return image;
    } else {
      await deniedPermission();
    }
    return null;
  }

  Future<List<File>> pickMultiImage(
      {required Future<void> Function() deniedPermission,
      double maxHeight = 1500,
      double maxWidth = 1500,
      int imageQuality = 90}) async {
    PermissionStatus status =
        await permissionHandler.requestPermission(PermissionType.photos);
    if (status == PermissionStatus.granted) {
      final images = await picker.pickMultiImage(
        maxHeight: maxHeight,
        maxWidth: maxHeight,
        imageQuality: imageQuality,
      );
      return images;
    } else {
      await deniedPermission();
    }
    return [];
  }
}

// @Riverpod(keepAlive: true)
// ImagePicker imagePicker(ImagePickerRef ref) => ImagePicker();

@Riverpod(keepAlive: true)
ImagePickerRepository imagePickerRepository(ImagePickerRepositoryRef ref) =>
    ImagePickerRepository(
        permissionHandler: ref.watch(permissionHandlerServiceProvider),
        picker: ref.watch(imagePickerServiceProvider));

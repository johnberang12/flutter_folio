// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common_widget/image_editing_controller.dart';
import '../data/image_picker_repository.dart';

part 'pick_image_service.g.dart';

//* a service class that is used to limit the images that a user can pick and assign the picked images to the controller
//*Unit test done
class PickImageService {
  PickImageService({
    required this.repository,
  });
  final ImagePickerRepository repository;
  final _imageLimit = 10;

  Future<void> pickMultiImage({
    required Future<void> Function() deniedPermission,
    required ImageEditingController<File> fileController,
    int? totalImages,
  }) async {
    int total = totalImages ?? fileController.length;
    final images =
        await repository.pickMultiImage(deniedPermission: deniedPermission);
    print('images: $images');
    if (images.isEmpty) return;
    for (var image in images) {
      if (total < _imageLimit) {
        total++;
        fileController.addItem(image);
      }
    }
  }

  Future<void> pickSingleGalleryImage(
      {required Future<void> Function() deniedPermission,
      required ImageEditingController<File> fileController}) async {
    final image = await repository.pickImage(
        source: ImageSource.gallery, deniedPermission: deniedPermission);
    if (image == null) return;
    fileController.replace(image);
  }

  Future<void> takeCameraImage({
    required Future<void> Function() deniedPermission,
    required ImageEditingController<File> fileController,
    required bool allowMultiple,
    int? totalImages,
  }) async {
    int total = totalImages ?? fileController.length;
    final image = await repository.pickImage(
        source: ImageSource.camera, deniedPermission: deniedPermission);

    if (image == null) return;
    if (allowMultiple) {
      if (total < _imageLimit) {
        total++;
        fileController.addItem(image);
      }
    } else {
      fileController.replace(image);
    }
  }
}

@Riverpod(keepAlive: true)
PickImageService pickImageService(PickImageServiceRef ref) =>
    PickImageService(repository: ref.watch(imagePickerRepositoryProvider));

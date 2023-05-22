import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'image_picker_service.g.dart';

// ImagePickerService is an abstract representation of the ImagePicker plugin. By using this
// interface, the ImagePickerRepository doesn't directly depend on the ImagePicker plugin.
// This abstraction allows us to substitute the real ImagePicker plugin with a mock implementation
// during testing, making it easier to simulate various conditions and responses.
abstract class ImagePickerInterface {
  Future<File?> pickImage({
    required ImageSource source,
    double maxHeight = 1500,
    double maxWidth = 1500,
    int imageQuality = 90,
  });
  Future<List<File>> pickMultiImage({
    double maxHeight = 1500,
    double maxWidth = 1500,
    int imageQuality = 90,
  });
}

//*an actual class that interacts with image_picker plugin
class ImagePickerService implements ImagePickerInterface {
  final ImagePicker _imagePicker = ImagePicker();
  @override
  Future<File?> pickImage({
    required ImageSource source,
    double maxHeight = 1500,
    double maxWidth = 1500,
    int imageQuality = 90,
  }) async {
    final image = await _imagePicker.pickImage(
        source: source,
        maxHeight: maxHeight,
        maxWidth: maxHeight,
        imageQuality: imageQuality);
//return the file if the image is not null
    return image == null ? null : File(image.path);
  }

  @override
  Future<List<File>> pickMultiImage({
    double maxHeight = 1500,
    double maxWidth = 1500,
    int imageQuality = 90,
  }) async {
    final List<File> files = [];
    final images = await _imagePicker.pickMultiImage(
        maxHeight: maxHeight, maxWidth: maxHeight, imageQuality: imageQuality);
    //returns the empty files if the images is empty
    if (images.isEmpty) return files;
    for (var image in images) {
      final file = File(image.path);
      files.add(file);
    }
    return files;
  }
}

@Riverpod(keepAlive: true)
ImagePickerService imagePickerService(ImagePickerServiceRef ref) =>
    ImagePickerService();

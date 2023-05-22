// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_folio/src/services/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'image_upload_repository.g.dart';

enum ImageExtension {
  jpeg(contentType: 'image/jpeg'),
  jpg(contentType: 'image/jpeg'),
  png(contentType: 'image/png'),
  pdf(contentType: 'application/pdf');

  const ImageExtension({required this.contentType});
  final String contentType;
}

//* unit test done
class ImageUploadRepository implements StorageService {
  ImageUploadRepository({
    required this.storage,
  });
  final FirebaseStorage storage;

  Future<String?> _uploadSingleFile(
      File? file, String path, SettableMetadata metadata) async {
    // throw Exception('upload failed');
    if (file != null) {
      final storageRef = storage.ref().child(path);
      final uploadTask = storageRef.putFile(file, metadata);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } else {
      return null;
    }
  }

  String _getExtension(File file) {
    return file.path.split('.').last;
  }

  String _getContentType(File file) {
    final ext = file.path.split('.').last;
    for (var ex in ImageExtension.values) {
      if (ex.name == ext) {
        return ex.contentType;
      }
    }
    return ImageExtension.jpeg.contentType;
  }

  @override
  Future<List<String>> uploadFileImages({
    required List<File?> files,
    required String path,
  }) async {
    final urls = <String>[];
    final removedDuplicates = files.toSet().toList();
    if (removedDuplicates.isNotEmpty) {
      for (var i = 0; i < removedDuplicates.length; i++) {
        final file = removedDuplicates[i];
        if (file != null) {
          final imagePath =
              '$path/${Random().nextInt(10000)}.${_getExtension(file)}';
          final url = await _uploadSingleFile(file, imagePath,
              SettableMetadata(contentType: _getContentType(file)));
          if (url != null) {
            urls.add(url);
          }
        }
      }
    }
    return urls;
  }

  @override
  Future<void> deleteImages(List<String> imageUrls) async {
    if (imageUrls.isNotEmpty) {
      for (var url in imageUrls) {
        await storage.refFromURL(url).delete();
      }
    }
  }
}

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) =>
    FirebaseStorage.instance;

@Riverpod(keepAlive: true)
ImageUploadRepository imageUploadRepository(ImageUploadRepositoryRef ref) =>
    ImageUploadRepository(storage: ref.watch(firebaseStorageProvider));

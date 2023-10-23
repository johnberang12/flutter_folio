import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'permission_handler_service.g.dart';

enum PermissionType {
  camera,
  photos,
  location,
}

// PermissionHandlerService is an abstract representation of the Permission plugin. Similar to ImagePickerService,
// this interface decouples the ImagePickerRepository from the Permission plugin. By using this interface,
// we can inject different implementations of PermissionHandler into ImagePickerRepository,
// which is particularly useful in testing scenarios. For example, in tests, we can use a mock implementation
// to control the permission status response and ensure our repository handles all cases correctly.
abstract class PermissionHandler {
  Future<PermissionStatus> requestPermission(PermissionType permissionType);
}

class PermissionHandlerService implements PermissionHandler {
  @override
  Future<PermissionStatus> requestPermission(
      PermissionType permissionType) async {
    switch (permissionType) {
      case PermissionType.camera:
        return await Permission.camera.request();
      case PermissionType.photos:
        if (Platform.isIOS) {
          return await Permission.photos.request();
        } else {
          return PermissionStatus.granted;
        }
      case PermissionType.location:
        return await Permission.location.request();
      default:
        throw ArgumentError('Unsupported permission type');
    }
  }
}

@Riverpod(keepAlive: true)
PermissionHandlerService permissionHandlerService(
        PermissionHandlerServiceRef ref) =>
    PermissionHandlerService();

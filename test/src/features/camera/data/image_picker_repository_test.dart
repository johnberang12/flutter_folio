@Timeout(Duration(milliseconds: 500))
import 'dart:io';

import 'package:flutter_folio/src/features/camera/data/image_picker_repository.dart';
import 'package:flutter_folio/src/services/image_picker_service.dart';
import 'package:flutter_folio/src/services/permission_handler_service.dart';
import 'package:flutter_test/flutter_test.dart';

//*uncomment if needed
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../mocks.dart';

void main() {
  late ImagePickerService mockImagePickerService;
  late PermissionHandlerService mockPermissionHandlerService;
  late ImagePickerRepository imagePickerRepository;

  setUp(() {
    mockImagePickerService = MockImagePickerService();
    mockPermissionHandlerService = MockPermissionHandlerService();
    imagePickerRepository = ImagePickerRepository(
      picker: mockImagePickerService,
      permissionHandler: mockPermissionHandlerService,
    );
  });

  group('ImagePickerRepository test', () {
    group('pickImage test', () {
      //pick image thru camera
      test(
          'pickImage calls the correct methods on ImagePickerService and PermissionHandlerService for camera',
          () async {
        //* Arrange
        int count = 0;
        Future<void> deniedPermission() async {
          count++;
        }

        when(() => mockPermissionHandlerService
                .requestPermission(PermissionType.camera))
            .thenAnswer((_) async => PermissionStatus.granted);
        when(() => mockImagePickerService.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => File('path/to/image'));

        //*call
        final result = await imagePickerRepository.pickImage(
            source: ImageSource.camera, deniedPermission: deniedPermission);
        //*assert
        expect(count, 0);
        expect(result, isA<File>());
        verify(() => mockPermissionHandlerService
            .requestPermission(PermissionType.camera)).called(1);
        verify(() =>
                mockImagePickerService.pickImage(source: ImageSource.camera))
            .called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(
          'calls deniedPermission callback when the user did not grant camera permission',
          () async {
        //* Arrange
        int count = 0;
        Future<void> deniedPermission() async {
          count++;
        }

        when(() => mockPermissionHandlerService
                .requestPermission(PermissionType.camera))
            .thenAnswer((_) async => PermissionStatus.denied);
        when(() => mockImagePickerService.pickImage(source: ImageSource.camera))
            .thenAnswer((_) async => File('path/to/image'));

        //*call
        final result = await imagePickerRepository.pickImage(
            source: ImageSource.camera, deniedPermission: deniedPermission);
        //*assert
        expect(count, 1);
        expect(result, null);
        verify(() => mockPermissionHandlerService
            .requestPermission(PermissionType.camera)).called(1);
        verifyNever(
            () => mockImagePickerService.pickImage(source: ImageSource.camera));
      }, timeout: const Timeout(Duration(milliseconds: 500)));

      //pick image thru device gallery
      test(
          'pickImage calls the correct methods on ImagePickerService and PermissionHandlerService for gallery',
          () async {
        //* Arrange
        int count = 0;
        Future<void> deniedPermission() async {
          count++;
        }

        when(() => mockPermissionHandlerService
                .requestPermission(PermissionType.photos))
            .thenAnswer((_) async => PermissionStatus.granted);
        when(() =>
                mockImagePickerService.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => File('path/to/image'));

        //*call
        final result = await imagePickerRepository.pickImage(
            source: ImageSource.gallery, deniedPermission: deniedPermission);
        //*assert
        expect(count, 0);
        expect(result, isA<File>());
        verify(() => mockPermissionHandlerService
            .requestPermission(PermissionType.photos)).called(1);
        verify(() =>
                mockImagePickerService.pickImage(source: ImageSource.gallery))
            .called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(
          'calls deniedPermission callback when the user did not grant photos permission',
          () async {
        //* Arrange
        int count = 0;
        Future<void> deniedPermission() async {
          count++;
        }

        when(() => mockPermissionHandlerService
                .requestPermission(PermissionType.photos))
            .thenAnswer((_) async => PermissionStatus.denied);
        when(() =>
                mockImagePickerService.pickImage(source: ImageSource.gallery))
            .thenAnswer((_) async => File('path/to/image'));

        //*call
        final result = await imagePickerRepository.pickImage(
            source: ImageSource.gallery, deniedPermission: deniedPermission);
        //*assert
        expect(count, 1);
        expect(result, null);
        verify(() => mockPermissionHandlerService
            .requestPermission(PermissionType.photos)).called(1);
        verifyNever(() =>
            mockImagePickerService.pickImage(source: ImageSource.gallery));
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('pickMultiImage test', () {
      test(
          'pickMultiImage calls the correct methods on ImagePickerService and PermissionHandlerService',
          () async {
        int count = 0;
        Future<void> deniedPermission() async {
          count++;
        }

        when(() => mockPermissionHandlerService
                .requestPermission(PermissionType.photos))
            .thenAnswer((_) async => PermissionStatus.granted);
        when(() => mockImagePickerService.pickMultiImage())
            .thenAnswer((_) async => [File('path/to/image')]);

        //*call
        final result = await imagePickerRepository.pickMultiImage(
            deniedPermission: deniedPermission);
        //*assert
        expect(count, 0);
        expect(result, isA<List<File>>());
        verify(() => mockPermissionHandlerService
            .requestPermission(PermissionType.photos)).called(1);
        verify(() => mockImagePickerService.pickMultiImage()).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(
          'calls deniedPermission callback when the user did not grant photos permission',
          () async {
        int count = 0;
        Future<void> deniedPermission() async {
          count++;
        }

        when(() => mockPermissionHandlerService
                .requestPermission(PermissionType.photos))
            .thenAnswer((_) async => PermissionStatus.denied);
        when(() => mockImagePickerService.pickMultiImage())
            .thenAnswer((_) async => [File('path/to/image')]);

        //*call
        final result = await imagePickerRepository.pickMultiImage(
            deniedPermission: deniedPermission);
        //*assert
        expect(count, 1);
        expect(result, []);
        verify(() => mockPermissionHandlerService
            .requestPermission(PermissionType.photos)).called(1);
        verifyNever(() => mockImagePickerService.pickMultiImage());
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

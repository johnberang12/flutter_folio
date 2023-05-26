import 'dart:io';

import 'package:flutter_folio/src/common_widget/image_editing_controller.dart';
import 'package:flutter_folio/src/features/camera/application/pick_image_service.dart';
import 'package:flutter_folio/src/features/product/presentation/add_product/camera_icon_button_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late PickImageService imageService;
  late CameraIconButtonController controller;
  late ImageEditingController<File> fileController;
  late StateError stateError;

  setUp(() {
    imageService = MockPickImageService();

    controller = CameraIconButtonController(service: imageService);
    fileController = ImageEditingController<File>();
    stateError = StateError('Something went wrong');
  });
  setUpAll(() {
    registerFallbackValue(ImageEditingController<File>());
  });

  group('CameraIconButtonController test', () {
    test('controller initial data state', () {
      verifyNever(() => imageService.takeCameraImage(
          deniedPermission: captureAny(named: 'deniedPermission'),
          fileController: captureAny(named: 'fileController'),
          allowMultiple: captureAny(named: 'allowMultiple')));
      verifyNever(() => imageService.pickSingleGalleryImage(
          deniedPermission: captureAny(named: 'deniedPermission'),
          fileController: captureAny(named: 'fileController')));
      expect(controller.debugState.hasError, false);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    group('openDeviceCamera test', () {
      test('openDeviceCamera success', () async {
        //* Arrange
        Future<void> deniedPermission() async {}

        when(() => imageService.takeCameraImage(
            deniedPermission: any(named: 'deniedPermission'),
            fileController: fileController,
            totalImages: any(named: 'totalImages'),
            allowMultiple: true)).thenAnswer((_) => Future<void>.value());
        //*call
        await controller.openDeviceCamera(
            fileController: fileController,
            deniedPermission: deniedPermission,
            totalImages: fileController.length);
        //*assert
        verify(() => controller.service.takeCameraImage(
            deniedPermission: any(named: 'deniedPermission'),
            fileController: fileController,
            totalImages: any(named: 'totalImages'),
            allowMultiple: true)).called(1);
        //verify that controller has not error
        expect(controller.debugState.hasError, false);
        expect(controller.debugState, isA<AsyncData>());
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('openDeviceCamera failure', () async {
        //* Arrange
        Future<void> deniedPermission() async {}
        when(() => imageService.takeCameraImage(
            deniedPermission: any(named: 'deniedPermission'),
            fileController: fileController,
            totalImages: any(named: 'totalImages'),
            allowMultiple: true)).thenAnswer((_) => Future.error(stateError));
        //*call
        await controller.openDeviceCamera(
            fileController: fileController,
            deniedPermission: deniedPermission,
            totalImages: fileController.length);
        //*assert
        verify(() => controller.service.takeCameraImage(
            deniedPermission: any(named: 'deniedPermission'),
            fileController: fileController,
            totalImages: any(named: 'totalImages'),
            allowMultiple: true)).called(1);
        expect(controller.debugState.hasError, true);
        expect(controller.debugState, isA<AsyncError>());
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('pickGalleryImages test', () {
      test('pickGalleryImages success', () async {
        //* Arrange
        Future<void> deniedPermission() async {}
        when(() => imageService.pickMultiImage(
                deniedPermission: any(named: 'deniedPermission'),
                fileController: fileController,
                totalImages: fileController.length))
            .thenAnswer((_) => Future.value());

        //*call
        await controller.pickGalleryImages(
            fileController: fileController,
            deniedPermission: deniedPermission,
            totalImages: fileController.length);
        //*assert

        verify(() => imageService.pickMultiImage(
            deniedPermission: any(named: 'deniedPermission'),
            fileController: fileController,
            totalImages: fileController.length)).called(1);
        expect(controller.debugState.hasError, false);
        expect(controller.debugState, isA<AsyncData<void>>());
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('pickGalleryImages failure', () async {
        //* Arrange
        Future<void> deniedPermission() async {}
        when(() => imageService.pickMultiImage(
                deniedPermission: any(named: 'deniedPermission'),
                fileController: fileController,
                totalImages: fileController.length))
            .thenAnswer((_) => Future.error(stateError));

        //*call
        await controller.pickGalleryImages(
            fileController: fileController,
            deniedPermission: deniedPermission,
            totalImages: fileController.length);
        //*assert

        verify(() => imageService.pickMultiImage(
            deniedPermission: any(named: 'deniedPermission'),
            fileController: fileController,
            totalImages: fileController.length)).called(1);
        expect(controller.debugState, isA<AsyncError<void>>());
        expect(controller.debugState.hasError, true);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

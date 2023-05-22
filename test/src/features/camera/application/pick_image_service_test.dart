@Timeout(Duration(milliseconds: 500))
import 'dart:io';

import 'package:flutter_folio/src/common_widget/image_editing_controller.dart';
import 'package:flutter_folio/src/features/camera/application/pick_image_service.dart';

//*uncomment if needed
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
//*uncomment if needed
  late MockImagePickerRepository mockImagePickerRepository;
  late PickImageService pickImageService;
  late ImageEditingController<File> fileController;

  setUp(() {
    mockImagePickerRepository = MockImagePickerRepository();
    pickImageService = PickImageService(
      repository: mockImagePickerRepository,
    );
    fileController = ImageEditingController<
        File>(); // setup this controller as per your implementation
  });

  group('PickImageService test', () {
    group('pickMultipleImages test', () {
      test('pickMultipleImages picks correct number of images', () async {
        //* Arrange
        when(() => mockImagePickerRepository.pickMultiImage(
                deniedPermission: any(named: 'deniedPermission')))
            .thenAnswer((_) async => [File('test1'), File('test2')]);

        // Act
        await pickImageService.pickMultiImage(
          deniedPermission: () async {},
          fileController: fileController,
          totalImages: 0,
        );

        // Assert
        verify(() => mockImagePickerRepository.pickMultiImage(
            deniedPermission: any(named: 'deniedPermission'))).called(1);
        expect(fileController.length, 2);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(
          'when fileController contains 9 images and the user picked another 3 images, file controller should contain 10',
          () async {
        //* Arrange
        when(() => mockImagePickerRepository.pickMultiImage(
                  deniedPermission: any(named: 'deniedPermission'),
                ))
            .thenAnswer((invocation) =>
                Future.value([File('test1'), File('test2'), File('test3')]));

        //*Act
        await pickImageService.pickMultiImage(
            deniedPermission: () async {},
            fileController: fileController,
            totalImages: 9);

        //*assert
        expect(fileController.length + 9, 10);
        verify(() => mockImagePickerRepository.pickMultiImage(
            deniedPermission: any(named: 'deniedPermission'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('pickeSingeGalleryImage test', () {
      //1. if file controller is empty, add the picked image,  2. if not empty replace the content with the newly picked image
      test(
          'fileController should contain the image picked if the fileController is empty',
          () async {
        //* Arrange
        final pickedFile = File('path1');
        when(() => mockImagePickerRepository.pickImage(
                source: ImageSource.gallery,
                deniedPermission: any(named: 'deniedPermission')))
            .thenAnswer((invocation) => Future.value(pickedFile));

        //*call
        await pickImageService.pickSingleGalleryImage(
            deniedPermission: () async {}, fileController: fileController);

        //*assert
        expect(fileController.value, [pickedFile]);
        verify(() => mockImagePickerRepository.pickImage(
            source: ImageSource.gallery,
            deniedPermission: any(named: 'deniedPermission'))).called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('pickSingleGalleryImage replaces old image with new one', () async {
        //* Arrange
        final oldFile = File('path0');
        final pickedFile = File('path1');
        fileController.replace(oldFile); //initially containes file
        when(() => mockImagePickerRepository.pickImage(
                source: ImageSource.gallery,
                deniedPermission: any(named: 'deniedPermission')))
            .thenAnswer((invocation) => Future.value(pickedFile));

        //*call
        expect(
            fileController.value, [oldFile]); //expects the it containes a file
        await pickImageService.pickSingleGalleryImage(
            deniedPermission: () async {}, fileController: fileController);
        //*assert
        expect(fileController.value, [
          pickedFile
        ]); //expects that the oldFile was replaced with the pickedFile
        verify(() => mockImagePickerRepository.pickImage(
            source: ImageSource.gallery,
            deniedPermission: any(named: 'deniedPermission'))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('takeCameraImage test', () {
      test(
          'takeCameraImage containes correct number of image when allowMultiple is true',
          () async {
        //* Arrange
        final oldFile = File('path0');
        final pickedFile = File('path1');
        fileController.addItem(oldFile);
        when(() => mockImagePickerRepository.pickImage(
                source: ImageSource.camera,
                deniedPermission: any(named: "deniedPermission")))
            .thenAnswer((invocation) => Future.value(pickedFile));
        expect(fileController.value, [oldFile]);
        //*call
        await pickImageService.takeCameraImage(
            deniedPermission: () async {},
            fileController: fileController,
            allowMultiple: true);

        //*assert
        expect(fileController.value, [oldFile, pickedFile]);
        verify(() => mockImagePickerRepository.pickImage(
            source: ImageSource.camera,
            deniedPermission: any(named: "deniedPermission"))).called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test(
          'fileController dont add item if the fileController already containes 10',
          () async {
        //* Arrange
        //  when().thenAnswer((invocation) => Future.value());
        final pickedFile = File('path1');
        when(() => mockImagePickerRepository.pickImage(
                source: ImageSource.camera,
                deniedPermission: any(named: "deniedPermission")))
            .thenAnswer((invocation) => Future.value(pickedFile));
        //*call
        await pickImageService.takeCameraImage(
            deniedPermission: () async {},
            fileController: fileController,
            allowMultiple: true,
            totalImages: 10);
        //*assert
        expect(fileController.length + 10, 10);
        verify(() => mockImagePickerRepository.pickImage(
            source: ImageSource.camera,
            deniedPermission: any(named: "deniedPermission"))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('fileController replaces old item if allowMultiple is false',
          () async {
        //* Arrange
        //  when().thenAnswer((invocation) => Future.value());
        final oldFile = File('path0');
        final pickedFile = File('path1');
        fileController.addItem(oldFile);
        when(() => mockImagePickerRepository.pickImage(
                source: ImageSource.camera,
                deniedPermission: any(named: "deniedPermission")))
            .thenAnswer((invocation) => Future.value(pickedFile));

        expect(fileController.value, [oldFile]);
        //*call
        await pickImageService.takeCameraImage(
            deniedPermission: () async {},
            fileController: fileController,
            allowMultiple: false);
        //*assert
        expect(fileController.value, [pickedFile]);
        verify(() => mockImagePickerRepository.pickImage(
            source: ImageSource.camera,
            deniedPermission: any(named: "deniedPermission"))).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_folio/src/constants/test_items.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/camera/data/image_picker_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../product_robot.dart';

//This test is to test and verify the following:
//1. tapping the done button without completing the form wont work
//2. when all fields are filled, confirmation dialog appears,
//3. confirmation dialog closes when either cancel or confirm is pressed

void main() {
  late ImagePickerRepository imagePickerRepository;
  late AuthRepository authRepository;
  late User testUser;

  setUp(() {
    authRepository = MockAuthRepository();
    imagePickerRepository = MockImagePickerRepository();
    testUser = MockUser();
  });

  setUpAll(() {
    registerFallbackValue(ImageSource.camera);
  });

  testWidgets(
      'add product screen shows confirmation dialog when all fields are filled',
      (tester) async {
    //Arrange
    final storageImage = [kTestImageFiles.last];
    // const source = ImageSource.camera;
    when(() => imagePickerRepository.pickImage(
            source: ImageSource.camera,
            deniedPermission: any(named: 'deniedPermission')))
        .thenAnswer((_) => Future.value(kTestImageFiles.first));
    when(() => imagePickerRepository.pickMultiImage(
            deniedPermission: any(named: 'deniedPermission')))
        .thenAnswer((_) => Future.value(storageImage));

    when(() => authRepository.currentUser).thenReturn(testUser);

    // when(() => productService.setProduct(any<Product>(), any<List<File>>()))
    //     .thenAnswer((_) => Future.value());
    final r = ProductRobot(tester);

    //call
    //*pump product screen
    await r.pumpAddProductScreen(authRepository, imagePickerRepository);
    r.expectAddProductScreen();
    // for (var element in tester.allWidgets) {
    //   print(element.toString());
    // }
    //*test submit product button
    await r.tapDoneButtonAndFailed();
    //tap cameraIconButton then press cancel
    //* test the cancel button of camera action sheet
    await r.tapCameraIconButtonAndCancel();
    //tap cameraIconButton and tap camera
    //* add image from device camera
    await r.addCameraImageAndGalleryImage();
    await r.tapDoneButtonAndFailed();
    //* add  product title
    await r.enterTitle();
    await r.tapDoneButtonAndFailed();
    //* add product price
    await r.enterPrice();
    await r.tapDoneButtonAndFailed();

    //* add product description
    await r.enterDescription();
    await r.tapDoneButtonAndSuccess();

    //* cancel confirmation dialog
    await r.cancelConfirmationDialog();
    //* submit and confirm
    //intergation test will cover the actual submission of product
    // await r.submitAndConfirm();
  });
}

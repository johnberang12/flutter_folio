// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/adaptive_action_sheet.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/camera/data/image_picker_repository.dart';
import 'package:flutter_folio/src/features/camera/presentation/camera_modal_popup.dart';
import 'package:flutter_folio/src/features/camera/presentation/image_input_field.dart';
import 'package:flutter_folio/src/features/product/presentation/add_product/add_product_screen.dart';
import 'package:flutter_folio/src/features/product/presentation/add_product/camera_icon_button.dart';
import 'package:flutter_folio/src/features/product/presentation/product/product_screen.dart';
import 'package:flutter_folio/src/features/product/presentation/product_list/product_list_screen.dart';
import 'package:flutter_folio/src/features/product/presentation/product_list/product_list_tile.dart';
import 'package:flutter_folio/src/features/routing/app_router/app_route.dart';
import 'package:flutter_folio/src/features/routing/bottom_natigation/tab_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class ProductRobot {
  ProductRobot(
    this.tester,
  );
  final WidgetTester tester;

  static const _testTitle = 'title101';
  static const _testPrice = '101';
  static const _testDescription = 'product description 101';

  Future<void> pumpAddProductScreen(
      AuthRepository authRepository, ImagePickerRepository repository) async {
    await tester.pumpWidget(ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          imagePickerRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: AddProductScreen(),
        )));

    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  void expectAddProductScreen() {
    final addProdAppbar = find.byKey(kAddProductScreenAppbarKey);
    expect(addProdAppbar, findsOneWidget);
    // final addProductText = find.textContaining('Done');
    // expect(addProductText, findsOneWidget);
  }

  Future<void> tapDoneButton() async {
    final doneButton = find.byKey(kOnSaveButtonKey);
    await _tap(doneButton);
  }

  void expectConfirmationDialog() {
    final confirmSubmissionDialog = find.textContaining('Confirm submission');
    final canceltext = find.textContaining('Cancel');
    final okText = find.textContaining('Ok');
    expect(confirmSubmissionDialog, findsOneWidget);
    expect(canceltext, findsOneWidget);
    expect(okText, findsOneWidget);
  }

  void expectNoConfirmationDialog() {
    final confirmSubmissionDialog = find.textContaining('Confirm submission');
    final canceltext = find.textContaining('Cancel');
    final okText = find.textContaining('Ok');
    expect(confirmSubmissionDialog, findsNothing);
    expect(canceltext, findsNothing);
    expect(okText, findsNothing);
  }

  Future<void> tapCancelButton() async {
    final canceltext = find.textContaining('Cancel');
    expect(canceltext, findsOneWidget);
    await _tap(canceltext);
  }

  Future<void> tapOkButton() async {
    final okText = find.textContaining('Ok');
    expect(okText, findsOneWidget);
    await _tap(okText);
  }

  Future<void> tapCameraIconButton() async {
    final cameraIconButton = find.byKey(kCameraIconButtonKey);
    expect(cameraIconButton, findsOneWidget);
    await _tap(cameraIconButton);
  }

  Future<void> tapDoneButtonAndFailed() async {
    await tapDoneButton();
    expectNoConfirmationDialog();
  }

  Future<void> tapDoneButtonAndSuccess() async {
    await tapDoneButton();
    expectConfirmationDialog();
  }

//* camera action sheet
  void expectCAS() {
    final cameraActionSheetTitle = find.byKey(kCameraActionSheetTitleKey);
    expect(cameraActionSheetTitle, findsOneWidget);
  }

  void expectNoCAS() {
    final cameraActionSheetTitle = find.byKey(kCameraActionSheetTitleKey);
    expect(cameraActionSheetTitle, findsNothing);
  }

  Future<void> tapCASCamera() async {
    final casCameraButton = find.byKey(kCASTitleCameraKey);
    await _tap(casCameraButton);
  }

  Future<void> tapCASGallery() async {
    final casGalleryButton = find.byKey(kCASTitlGalleryKey);
    await _tap(casGalleryButton);
  }

  Future<void> tapCASCancel() async {
    // final casCancelButton = find.byType(CancelAction);
    final casCancelButton = find.byKey(kCancelActionKey);
    await _tap(casCancelButton);
  }

  Future<void> _tap(Finder finder,
      {Duration duration = const Duration(milliseconds: 100)}) async {
    await tester.tap(finder);
    await tester.pumpAndSettle(duration);
  }

  Future<void> tapCameraIconButtonAndCancel() async {
    await tapCameraIconButton();
    expectCAS();
    await tapCASCancel();
    expectNoCAS();
  }

  Future<void> addCameraImageAndGalleryImage() async {
    await tapCameraIconButton();
    await tapCASCamera();
    expectNoCAS();
    expectImages(1);

    await tapCameraIconButton();
    await tapCASGallery();
    expectNoCAS();
    expectImages(2);
  }

  void expectImages(int num) {
    final image = find.byType(ImageTile<File>);
    expect(image.evaluate().length, num);
  }

  //** */ //** */TextFormFields
  Future<void> enterTitle() async {
    final titleTextField = find.byKey(kProductTitleFieldKey);
    expect(titleTextField, findsOneWidget);
    await tester.enterText(titleTextField, _testTitle);
    await tester.pump();
  }

  Future<void> enterPrice() async {
    final priceTextField = find.byKey(kProductPriceFieldKey);
    expect(priceTextField, findsOneWidget);
    await tester.enterText(priceTextField, _testPrice);
    await tester.pump();
  }

  Future<void> enterDescription() async {
    final descriptionTextField = find.byKey(kProductDescriptionFieldKey);
    expect(descriptionTextField, findsOneWidget);
    await tester.enterText(descriptionTextField, _testDescription);
    await tester.pump();
  }

  Future<void> cancelConfirmationDialog() async {
    await tapCancelButton();
    expectNoConfirmationDialog();
  }

  Future<void> submitAndConfirm() async {
    await tapDoneButton();
    await tapOkButton();
    expectNoConfirmationDialog();
  }

  void expectNumberOfProduct(int num) {
    final productListTile = find.byType(ProductListTile);
    expect(productListTile.evaluate().length, num);
  }

  Future<void> tapProductListTile() async {
    final productListTile = find.byKey(kProductTileKey);
    await _tap(productListTile);
  }

  void expectProductScreen() {
    final prodScreenBody = find.byKey(kProdScreenBodyKey);
    expect(prodScreenBody, findsOneWidget);
  }

  void expectCorrectProductDescription() {
    final prodTitle = find.text(_testTitle);
    final prodPrice = find.textContaining(_testPrice);
    final prodDescription = find.text(_testDescription);
    expect(prodTitle, findsOneWidget);
    //price is converted to formatted price in the UI
    //so to simplify, expect all wdgets that contains the price
    //in this example 3 widgets is expected
    expect(prodPrice, findsNWidgets(3));
    expect(prodDescription, findsOneWidget);
  }

  //used for integration test

  Future<void> goToHomeScreen() async {
    final container = ProviderContainer();
    final location = container.read(goRouterProvider).location;
    if (location != '/home') {
      container.read(goRouterProvider).goNamed(AppRoute.home.name);
    } else {
      final homeTabIcon = find.byKey(kHomeIconTabKey);
      await _tap(homeTabIcon);
      final productListScreen = find.byType(ProductListScreen);
      expect(productListScreen, findsOneWidget);
    }
  }

  Future<void> goToAddProductScreen() async {
    final appFAB = find.byKey(homeFABKey);
    // await tester.pumpAndSettle(const Duration(milliseconds: 5000));
    await tester.ensureVisible(appFAB);
    await _tap(appFAB);
  }

  Future<void> createProductAndSubmit() async {
    await addCameraImageAndGalleryImage();
    await enterTitle();
    await enterPrice();
    await enterDescription();
    await submitAndConfirm();
    expectNumberOfProduct(1);
  }

  Future<void> goToProductScreenAndVirifyContent() async {
    await tapProductListTile();
    expectProductScreen();
    expectCorrectProductDescription();
    final backButton = find.byIcon(Icons.arrow_back_ios_new_outlined);
    await _tap(backButton);
  }
}

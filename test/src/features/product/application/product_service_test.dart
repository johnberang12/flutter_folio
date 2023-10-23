import 'dart:io';

import 'package:flutter_folio/src/features/image_upload/image_upload_repository.dart';
import 'package:flutter_folio/src/features/product/application/product_service.dart';
import 'package:flutter_folio/src/features/product/data/product_repository.dart';
import 'package:flutter_folio/src/features/product/domain/product.dart';
import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:flutter_folio/src/utils/owner_verifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fakes/fake_connection_checker.dart';
import '../../../fakes/fake_owner_verifier.dart';
import '../../../mocks.dart';

void main() {
  const ownerId = 'ownerId';
  ConnectionChecker withConnectionChecker =
      FakeConnectionChecker(connection: true);
  ConnectionChecker withoutConnectionChecker =
      FakeConnectionChecker(connection: false);
  OwnerVerifier ownerVerifier = FakeOwnerVerifier(userId: ownerId);
  ImageUploadRepository imageUploadRepository = MockImageUploadRepository();
  ProductRepository productRepository = MockProductRepository();

  // setUpAll(() {

  // });

  ProductService makeConnectionProductService() {
    final container = ProviderContainer(overrides: [
      connectionCheckerProvider.overrideWithValue(withConnectionChecker),
      ownerVerifierProvider.overrideWithValue(ownerVerifier),
      imageUploadRepositoryProvider.overrideWithValue(imageUploadRepository),
      productRepositoryProvider.overrideWithValue(productRepository),
    ]);

    return container.read(productServiceProvider);
  }

  ProductService makeNoConnectionProductService() {
    final container = ProviderContainer(overrides: [
      connectionCheckerProvider.overrideWithValue(withoutConnectionChecker),
      ownerVerifierProvider.overrideWithValue(ownerVerifier),
      imageUploadRepositoryProvider.overrideWithValue(imageUploadRepository),
      productRepositoryProvider.overrideWithValue(productRepository),
    ]);

    return container.read(productServiceProvider);
  }

  group('ProductService test', () {
    final photos1 = ['photos1'];
    final product = Product(
        id: 'id',
        title: 'title',
        description: 'description',
        price: 101,
        photos: photos1,
        ownerId: ownerId);
    group('setProduct test', () {
      test(
          'correctly calls uploadFileImages and setProduct when the user is the ownerId and connection is true ',
          () async {
        //* Arrange
        final productService = makeConnectionProductService();

        final photos2 = ['photos'];
        final finalPhotos = [...photos1, ...photos2];
        final testFiles = [File('test_path')];

        late Product finalProduct;

        final defaultProduct = product.copyWith(photos: finalPhotos);

        when(() => imageUploadRepository.uploadFileImages(
            files: any(named: 'files'),
            path: any(named: 'path'))).thenAnswer((_) => Future.value(photos2));
        when(() => productRepository.setProduct(defaultProduct))
            .thenAnswer((invocation) {
          finalProduct = invocation.positionalArguments[0] as Product;
          return Future.value();
        });

        //*call
        await productService.setProduct(product, testFiles);

        // //*assert
        expect(finalProduct.photos, finalPhotos);
        verify(() => imageUploadRepository.uploadFileImages(
            files: any(named: 'files'), path: any(named: 'path'))).called(1);
        verify(() => productRepository.setProduct(finalProduct)).called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('throws a state error when the user is not the product owner',
          () async {
        //* Arrange
        final productService = makeConnectionProductService();
        final files = [File('path1')];
        final product = Product(
            id: 'id',
            title: 'title',
            description: 'description',
            price: 101,
            photos: ['photos1'],
            ownerId: 'notOwner');

        when(() => imageUploadRepository.uploadFileImages(
            files: any(named: 'files'),
            path: any(named: 'path'))).thenAnswer((_) => Future.value([]));
        when(() => productRepository.setProduct(product))
            .thenAnswer((invocation) {
          return Future.value();
        });

        //*call
        expect(() async => productService.setProduct(product, files),
            throwsA(isA<StateError>()));
        // //*assert

        verifyNever(() => imageUploadRepository.uploadFileImages(
            files: any(named: 'files'), path: any(named: 'path')));
        verifyNever(() => productRepository.setProduct(product));
      }, timeout: const Timeout(Duration(milliseconds: 500)));

      test('throws a state error when connection is false', () async {
        //* Arrange
        final productService = makeNoConnectionProductService();
        final files = [File('path1')];
        final product = Product(
            id: 'id',
            title: 'title',
            description: 'description',
            price: 101,
            photos: ['photos1'],
            ownerId: ownerId);

        when(() => imageUploadRepository.uploadFileImages(
            files: any(named: 'files'),
            path: any(named: 'path'))).thenAnswer((_) => Future.value([]));
        when(() => productRepository.setProduct(product))
            .thenAnswer((invocation) {
          return Future.value();
        });

        //*call
        expect(() async => productService.setProduct(product, files),
            throwsA(isA<StateError>()));
        // //*assert

        verifyNever(() => imageUploadRepository.uploadFileImages(
            files: any(named: 'files'), path: any(named: 'path')));
        verifyNever(() => productRepository.setProduct(product));
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
    group('deleteteProduct test', () {
      test(
          'verify that delete product and delete images are called when connection is true with correct parameter',
          () async {
        //* Arrange
        final productService = makeConnectionProductService();
        when(() => productRepository.deleteProduct(product))
            .thenAnswer((_) => Future.value());
        when(() => imageUploadRepository.deleteImages(product.photos))
            .thenAnswer((_) => Future.value());

        //*call
        await productService.deleteProduct(product);
        //*assert
        // expect(, );
        verify(() => productRepository.deleteProduct(product)).called(1);
        verify(() => imageUploadRepository.deleteImages(product.photos))
            .called(1);
        //  verifyNever();
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('throws StateError when productOwner is not the user', () async {
        //* Arrange
        final testProduct = product.copyWith(ownerId: 'notOwner');
        final productService = makeConnectionProductService();
        when(() => productRepository.deleteProduct(testProduct))
            .thenAnswer((_) => Future.value());
        when(() => imageUploadRepository.deleteImages(testProduct.photos))
            .thenAnswer((_) => Future.value());

        //*call
        expect(() async => productService.deleteProduct(testProduct),
            throwsA(isA<StateError>()));
        //*assert
        // expect(, );
        verifyNever(() => productRepository.deleteProduct(testProduct));
        verifyNever(
            () => imageUploadRepository.deleteImages(testProduct.photos));
      }, timeout: const Timeout(Duration(milliseconds: 500)));
      test('throws StateError when connection is false', () async {
        //* Arrange

        final productService = makeNoConnectionProductService();
        when(() => productRepository.deleteProduct(product))
            .thenAnswer((_) => Future.value());
        when(() => imageUploadRepository.deleteImages(product.photos))
            .thenAnswer((_) => Future.value());

        //*call
        expect(() async => productService.deleteProduct(product),
            throwsA(isA<StateError>()));
        //*assert
        // expect(, );
        verifyNever(() => productRepository.deleteProduct(product));
        verifyNever(() => imageUploadRepository.deleteImages(product.photos));
      }, timeout: const Timeout(Duration(milliseconds: 500)));
    });
  });
}

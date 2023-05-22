import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_folio/src/features/product/data/product_repository.dart';
import 'package:flutter_folio/src/features/product/domain/product.dart';
import 'package:flutter_folio/src/services/firestore_service/firestore_path.dart';

//*uncomment if needed
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fakes/fake_query.dart';
import '../../../mocks.dart';

void main() {
  late MockFirestoreService service;
  late ProductRepository repository;

  setUp(() {
    service = MockFirestoreService();
    repository = ProductRepository(service: service);
  });

  group('ProductRepository test', () {
    final testProduct = Product(
        id: 'id',
        title: 'title',
        description: 'description',
        price: 101,
        photos: ['photos'],
        ownerId: 'ownerId');
    test('verify that setProduct correctly calls seData() with parameter',
        () async {
      //* Arrange
//setProduct test
      when(() => service.setData(
          path: FirestorePath.product(testProduct.id),
          data: testProduct.toMap())).thenAnswer((_) => Future.value());

      // //*call
      await repository.setProduct(testProduct);
      // //*assert

      verify(() => service.setData(
          path: FirestorePath.product(testProduct.id),
          data: testProduct.toMap())).called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));
    //deleteProduct test
    test('verify that deleteProduct correctly calls the deleteData()',
        () async {
      //* Arrange

      when(() =>
              service.deleteData(path: FirestorePath.product(testProduct.id)))
          .thenAnswer((_) => Future.value());

      //*call
      await repository.deleteProduct(testProduct);
      //*assert

      verify(() =>
              service.deleteData(path: FirestorePath.product(testProduct.id)))
          .called(1);
    }, timeout: const Timeout(Duration(milliseconds: 500)));

//productQuery test
    test('productQuery return a type Query<Product>', () async {
      //* Arrange
      when(() => service.collectionQuery<Product>(
            path: FirestorePath.products(),
            fromMap: captureAny(named: 'fromMap'),
            toMap: captureAny(named: 'toMap'),
          )).thenReturn(FakeQuery<Product>());

      //*call
      final query = repository.productQuery();
      //*assert
      expect(query, isA<Query<Product>>());
    }, timeout: const Timeout(Duration(milliseconds: 500)));

//watchProduct test
    test('watchProduct emits expected product stream', () async {
      //* Arrange
      const ProductID productId = 'productId';
      final product = testProduct.copyWith(id: productId);

      when(() => service.documentStream<Product>(
            path: captureAny(named: 'path'),
            builder: captureAny(named: 'builder'),
          )).thenAnswer((_) => Stream.value(product));

      //*call
      final result = repository.watchProduct(product.id);

      // //*assert
      expectLater(result, emits(product));
    }, timeout: const Timeout(Duration(milliseconds: 500)));
  });
}

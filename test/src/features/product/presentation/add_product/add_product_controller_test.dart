import 'dart:io';

import 'package:flutter_folio/src/constants/test_items.dart';
import 'package:flutter_folio/src/features/product/application/product_service.dart';
import 'package:flutter_folio/src/features/product/domain/product.dart';
import 'package:flutter_folio/src/features/product/presentation/add_product/add_product_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  ProviderContainer makeProviderContainer(MockProductService productService) {
    final container = ProviderContainer(
        overrides: [productServiceProvider.overrideWithValue(productService)]);

    addTearDown(container.dispose);
    return container;
  }

  late StateError stateError;
  late Product product;
  late List<File> files;

  setUp(() {
    stateError = StateError('Something went wrong');
    product = kTestProducts.first;
    files = [File('path1')];
  });

  setUpAll(() {
    registerFallbackValue(const AsyncLoading());
  });

  group('AddProductController test', () {
    test('initial state is AsyncData', () {
      final productService = MockProductService();

      final container = makeProviderContainer(productService);
//create a listener
      final listener = Listener<AsyncValue<void>>();
//listen to the provider and call [listener] when its value changes
      container.listen<AsyncValue<void>>(addProductControllerProvider, listener,
          fireImmediately: true);
//verify that the controller has an initial value of AsyncData(null)
      verify(() => listener(null, const AsyncData<void>(null)));
//verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      //verify that the productService.deleteProduct is not called
      verifyNever(() => productService.setProduct(product, files));
      //verify that the accountService.deleteAccount() is not called
    });
    group('addProduct test', () {
      test('addProduct success', () async {
        //* Arrange
        final productService = MockProductService();
        when(() => productService.setProduct(product, files))
            .thenAnswer((_) => Future.value());
        final container = makeProviderContainer(productService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            addProductControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(addProductControllerProvider.notifier);
        await controller.addProduct(product, files);
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(any(that: isA<AsyncLoading>()), data),
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => productService.setProduct(product, files)).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 700)));
      test('addProduct Failed', () async {
        //* Arrange
        final productService = MockProductService();
        when(() => productService.setProduct(product, files))
            .thenAnswer((_) => Future.error(stateError));
        final container = makeProviderContainer(productService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            addProductControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(addProductControllerProvider.notifier);
        await controller.addProduct(product, files);
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => productService.setProduct(product, files)).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 700)));
    });
  });
}

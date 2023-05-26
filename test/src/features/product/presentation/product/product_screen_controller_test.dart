import 'package:flutter_folio/src/constants/test_items.dart';
import 'package:flutter_folio/src/features/product/application/product_service.dart';
import 'package:flutter_folio/src/features/product/domain/product.dart';
import 'package:flutter_folio/src/features/product/presentation/product/product_screen_controller.dart';
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

  setUp(() {
    stateError = StateError('Something went wrong');
    product = kTestProducts.first;
  });

  setUpAll(() {
    registerFallbackValue(const AsyncLoading());
  });

  group('ProductScreenController test', () {
    test('initial state is AsyncData', () {
      final productService = MockProductService();

      final container = makeProviderContainer(productService);
//create a listener
      final listener = Listener<AsyncValue<void>>();
//listen to the provider and call [listener] when its value changes
      container.listen<AsyncValue<void>>(
          productScreenControllerProvider, listener,
          fireImmediately: true);
//verify that the controller has an initial value of AsyncData(null)
      verify(() => listener(null, const AsyncData<void>(null)));
//verify that the listener is no longer called
      verifyNoMoreInteractions(listener);
      //verify that the productService.deleteProduct is not called
      verifyNever(() => productService.deleteProduct(product));
      //verify that the accountService.deleteAccount() is not called
    });
    group('deleteProduct test', () {
      test('deleteProduct success', () async {
        //* Arrange
        final productService = MockProductService();
        when(() => productService.deleteProduct(product))
            .thenAnswer((_) => Future.value());
        final container = makeProviderContainer(productService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            productScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(productScreenControllerProvider.notifier);
        await controller.deleteProduct(product);
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(any(that: isA<AsyncLoading>()), data),
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => productService.deleteProduct(product)).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 700)));
      test('deleteProduct Failed', () async {
        //* Arrange
        final productService = MockProductService();
        when(() => productService.deleteProduct(product))
            .thenAnswer((_) => Future.error(stateError));
        final container = makeProviderContainer(productService);
        final listener = Listener<AsyncValue<void>>();

        container.listen<AsyncValue<void>>(
            productScreenControllerProvider, listener,
            fireImmediately: true);

        const data = AsyncData<void>(null);

        verify(() => listener(null, data));
        //*call
        final controller =
            container.read(productScreenControllerProvider.notifier);
        await controller.deleteProduct(product);
        //*assert
        verifyInOrder([
          () => listener(data, any(that: isA<AsyncLoading>())),
          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ]);

        verifyNoMoreInteractions(listener);
        verify(() => productService.deleteProduct(product)).called(1);
      }, timeout: const Timeout(Duration(milliseconds: 700)));
    });
  });
}

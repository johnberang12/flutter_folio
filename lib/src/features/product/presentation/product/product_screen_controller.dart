import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/product_service.dart';
import '../../domain/product.dart';

part 'product_screen_controller.g.dart';

@riverpod
class ProductScreenController extends _$ProductScreenController {
  @override
  FutureOr<void> build() {}
  Future<bool> deleteProduct(Product product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(productServiceProvider).deleteProduct(product));
    return state.hasError == false;
  }
}

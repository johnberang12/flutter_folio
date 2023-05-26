import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/product_service.dart';
import '../../domain/product.dart';

part 'add_product_controller.g.dart';

//* unit test done
@riverpod
class AddProductController extends _$AddProductController {
  @override
  FutureOr<void> build() {}

  Future<bool> addProduct(Product product, List<File> images) async {
    //set the state to loading before performing an api call
    state = const AsyncLoading();
    //calling an api call and saving its result to the state.
    //api call is wrapped with AsyncValue.guard(). this method is used to catch possible error or exception thrown by firestore
    //or any api service/repositories.
    state = await AsyncValue.guard(
        () => ref.read(productServiceProvider).setProduct(product, images));
    //finally returns boolean wether the operation is successful or not.
    //the purpose of this is to be able to perform additional operation when successful like showing success message or navigating the user to another screen.
    return state.hasError == false;
  }

  Future<void> editProduct(Product product) async {}
}

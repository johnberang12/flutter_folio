// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/firestore_service/firestore_path.dart';
import '../../../services/firestore_service/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/product.dart';
part 'product_repository.g.dart';

String idFromCurrentDate() => DateTime.now().toString();

//* unit test done
//all unit test here is to simply check if the FirestoreService methods are correctly being called
class ProductRepository {
  ProductRepository({
    required this.service,
  });
  final FirestoreService service;

  Future<void> setProduct(Product product) => service.setData(
      path: FirestorePath.product(product.id), data: product.toMap());

//delete operation
  Future<void> deleteProduct(Product product) =>
      service.deleteData(path: FirestorePath.product(product.id));

  Query<Product> productQuery() => service.collectionQuery<Product>(
      path: FirestorePath.products(),
      fromMap: (snapshot, _) => Product.fromMap(snapshot.data() ?? {}),
      toMap: (product, _) => product.toMap());

  Stream<Product> watchProduct(ProductID productId) => service.documentStream(
      path: FirestorePath.product(productId),
      builder: (data) => Product.fromMap(data ?? {}));
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) =>
    ProductRepository(service: ref.watch(firestoreServiceProvider));

@riverpod
Stream<Product> productStream(ProductStreamRef ref, ProductID productId) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.watchProduct(productId);
}

@riverpod
Query<Product> productQuery(ProductQueryRef ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.productQuery();
}

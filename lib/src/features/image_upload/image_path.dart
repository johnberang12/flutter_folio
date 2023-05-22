import '../product/domain/product.dart';

class ImagePath {
  static String product(ProductID productId) => 'products/$productId';
}

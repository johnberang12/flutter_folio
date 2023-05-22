import '../../features/app_user/domain/app_user.dart';
import '../../features/product/domain/product.dart';

class FirestorePath {
  static String user(UserID userId) => 'users/$userId';
  static String users() => 'users';

  static String product(ProductID productId) => 'products/$productId';
  static String products() => 'products';
}

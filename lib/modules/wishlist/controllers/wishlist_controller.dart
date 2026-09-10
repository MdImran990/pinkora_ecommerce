import 'package:get/get.dart';
import '../../../data/model/product_model.dart';

class WishlistController extends GetxController {
  final wishlistItems = <ProductModel>[].obs;

  void removeItem(ProductModel product) {
    wishlistItems.remove(product);
  }

  bool get isEmpty => wishlistItems.isEmpty;
}
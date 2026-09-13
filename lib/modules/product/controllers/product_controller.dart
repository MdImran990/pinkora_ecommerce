import 'package:get/get.dart';

import '../../../data/model/product_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/wishlist/controllers/wishlist_controller.dart';

class ProductController extends GetxController {
  final product = Rxn<ProductModel>();

  final selectedColor = ''.obs;
  final selectedSize = ''.obs;
  final quantity = 1.obs;
  final currentImageIndex = 0.obs;
  final isWishlisted = false.obs;

  late final CartController _cartCtrl;
  late final WishlistController _wishCtrl;

  @override
  void onInit() {
    super.onInit();

    _cartCtrl = Get.find<CartController>();
    _wishCtrl = Get.find<WishlistController>();

    // Product argument
    if (Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
    } else {
      // Default product
      product.value = ProductModel(
        id: '1',
        name: 'Trendy Handbag',
        image: '',
        price: 2100,
        originalPrice: 3000,
        discountPercent: 30,
        rating: 4.8,
        reviewCount: 120,
        category: 'Fashion',
        colors: [
          '#FF6B9D',
          '#000000',
          '#D4A574',
          '#F5E6D3',
        ],
      );
    }

    final p = product.value;

    if (p != null) {
      if (p.colors.isNotEmpty) {
        selectedColor.value = p.colors.first;
      }

      isWishlisted.value = _wishCtrl.isWished(p.id);
    }
  }

  // =========================
  // COLOR
  // =========================

  void selectColor(String color) {
    selectedColor.value = color;
  }

  // =========================
  // SIZE
  // =========================

  void selectSize(String size) {
    selectedSize.value = size;
  }

  // =========================
  // WISHLIST
  // =========================

  void toggleWishlist() {
    final p = product.value;

    if (p == null) return;

    if (_wishCtrl.isWished(p.id)) {
      _wishCtrl.removeItem(p);
      isWishlisted.value = false;
    } else {
      _wishCtrl.addItem(p);
      isWishlisted.value = true;
    }
  }

  // =========================
  // QUANTITY
  // =========================

  void increaseQty() {
    quantity.value++;
  }

  void decreaseQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // =========================
  // IMAGE
  // =========================

  void changeImage(int index) {
    currentImageIndex.value = index;
  }

  // =========================
  // ADD TO CART
  // =========================

  void addToCart() {
    final p = product.value;

    if (p == null) return;

    _cartCtrl.addToCart(
      p,
      color: selectedColor.value,
      size: selectedSize.value,
      qty: quantity.value,
    );
  }

  // =========================
  // BUY NOW
  // =========================

  void buyNow() {
    final p = product.value;

    if (p == null) return;

    // Add product to cart first
    _cartCtrl.addToCart(
      p,
      color: selectedColor.value,
      size: selectedSize.value,
      qty: quantity.value,
    );

    // Go directly to checkout
    Get.toNamed(AppRoutes.checkout);
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
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

  late CartController _cartCtrl;
  late WishlistController _wishCtrl;

  @override
  void onInit() {
    super.onInit();
    _cartCtrl = Get.find<CartController>();
    _wishCtrl = Get.find<WishlistController>();

    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
    } else {
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
        colors: ['#FF6B9D', '#000000', '#D4A574', '#F5E6D3'],
      );
    }

    if (product.value!.colors.isNotEmpty) {
      selectedColor.value = product.value!.colors.first;
    }

    // sync wishlist state
    isWishlisted.value =
        _wishCtrl.isWished(product.value!.id);
  }

  void selectColor(String color) => selectedColor.value = color;
  void selectSize(String size) => selectedSize.value = size;

  void toggleWishlist() {
    final p = product.value!;
    if (_wishCtrl.isWished(p.id)) {
      _wishCtrl.removeItem(p);
      isWishlisted.value = false;
    } else {
      _wishCtrl.addItem(p);
      isWishlisted.value = true;
    }
  }

  void increaseQty() => quantity.value++;
  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void changeImage(int index) => currentImageIndex.value = index;

  void addToCart() {
    final p = product.value!;
    _cartCtrl.addToCart(
      p,
      color: selectedColor.value,
      size: selectedSize.value,
      qty: quantity.value,
    );
  }

  void buyNow() {
    addToCart();
    Get.toNamed(AppRoutes.checkout);
  }
}
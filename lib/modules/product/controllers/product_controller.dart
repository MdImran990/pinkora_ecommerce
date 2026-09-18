import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/model/product_model.dart';
import '../../../modules/cart/controllers/cart_controller.dart';
import '../../../modules/wishlist/controllers/wishlist_controller.dart';
class ProductController extends GetxController {
  final Rxn<ProductModel> product = Rxn<ProductModel>();

  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxInt quantity = 1.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isWishlisted = false.obs;

  late final CartController _cartCtrl;
  late final WishlistController _wishCtrl;

  @override
  void onInit() {
    super.onInit();

    _cartCtrl = Get.find<CartController>();
    _wishCtrl = Get.find<WishlistController>();

    _loadProduct();
  }

  void _loadProduct() {
    final argument = Get.arguments;

    final loadedProduct = argument is ProductModel
        ? argument
        : _fallbackProduct;

    product.value = loadedProduct;

    selectedColor.value = loadedProduct.colors.isNotEmpty
        ? loadedProduct.colors.first
        : '';

    selectedSize.value = '';
    quantity.value = 1;
    currentImageIndex.value = 0;

    isWishlisted.value =
        _wishCtrl.isWished(loadedProduct.id);
  }

  static final ProductModel _fallbackProduct = ProductModel(
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

  void selectColor(String color) {
    if (selectedColor.value == color) return;

    selectedColor.value = color;
  }

  void selectSize(String size) {
    if (selectedSize.value == size) return;

    selectedSize.value = size;
  }

  void toggleWishlist() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    final wished =
    _wishCtrl.isWished(currentProduct.id);

    if (wished) {
      _wishCtrl.removeItem(currentProduct);
      isWishlisted.value = false;
    } else {
      _wishCtrl.addItem(currentProduct);
      isWishlisted.value = true;
    }
  }

  void increaseQty() {
    quantity.value++;
  }

  void decreaseQty() {
    if (quantity.value <= 1) return;

    quantity.value--;
  }

  void changeImage(int index) {
    if (index < 0) return;
    if (currentImageIndex.value == index) return;

    currentImageIndex.value = index;
  }

  void addToCart() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    _cartCtrl.addToCart(
      currentProduct,
      color: selectedColor.value,
      size: selectedSize.value,
      qty: quantity.value,
    );

    Get.snackbar(
      '✅ Added!',
      '${currentProduct.name} cart এ যোগ হয়েছে',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 800),
    );
  }

  void buyNow() {
    final currentProduct = product.value;

    if (currentProduct == null) return;

    _cartCtrl.addToCart(
      currentProduct,
      color: selectedColor.value,
      size: selectedSize.value,
      qty: quantity.value,
    );

    Get.toNamed(AppRoutes.checkout);
  }
}
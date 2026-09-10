import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class ProductController extends GetxController {
  final product = Rxn<ProductModel>();
  final selectedColor = ''.obs;
  final selectedSize = ''.obs;
  final quantity = 1.obs;
  final currentImageIndex = 0.obs;
  final isWishlisted = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is ProductModel) {
      product.value = Get.arguments as ProductModel;
      if (product.value!.colors.isNotEmpty) {
        selectedColor.value = product.value!.colors.first;
      }
      if (product.value!.sizes.isNotEmpty) {
        selectedSize.value = product.value!.sizes.first;
      }
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
  }

  void selectColor(String color) => selectedColor.value = color;
  void selectSize(String size) => selectedSize.value = size;
  void toggleWishlist() => isWishlisted.toggle();
  void increaseQty() => quantity.value++;
  void decreaseQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void changeImage(int index) => currentImageIndex.value = index;

  void addToCart() {
    Get.snackbar(
      'Added to Cart!',
      '${product.value?.name} added successfully',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void buyNow() => Get.toNamed(AppRoutes.checkout);
}
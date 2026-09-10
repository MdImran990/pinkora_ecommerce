import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class CartController extends GetxController {
  final cartItems = <CartItemModel>[].obs;
  final couponController = TextEditingController();
  final discount = 0.0.obs;
  final double deliveryFee = 80.0;

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get itemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get total => subtotal + deliveryFee - discount.value;

  @override
  void onInit() {
    super.onInit();
    _loadDummyCart();
  }

  void _loadDummyCart() {
    cartItems.value = [
      CartItemModel(
        product: ProductModel(
          id: '1',
          name: 'Trendy Handbag',
          image: '',
          price: 2100,
          originalPrice: 3000,
          discountPercent: 30,
          rating: 4.8,
          reviewCount: 120,
          category: 'Fashion',
          colors: ['#FF6B9D'],
        ),
        quantity: 1,
        selectedColor: 'Pink',
      ),
      CartItemModel(
        product: ProductModel(
          id: '2',
          name: 'Sport Shoes',
          image: '',
          price: 3200,
          originalPrice: 4300,
          discountPercent: 25,
          rating: 4.6,
          reviewCount: 98,
          category: 'Shoes',
        ),
        quantity: 1,
        selectedSize: 'White, 42',
      ),
      CartItemModel(
        product: ProductModel(
          id: '3',
          name: 'Smart Watch',
          image: '',
          price: 4500,
          originalPrice: 7500,
          discountPercent: 40,
          rating: 4.7,
          reviewCount: 86,
          category: 'Watches',
          colors: ['#000000'],
        ),
        quantity: 1,
        selectedColor: 'Black',
      ),
    ];
  }

  void increaseQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
    Get.snackbar(
      'Removed',
      'Item removed from cart',
      backgroundColor: AppColors.sale,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();
    if (code == 'PINKORA50') {
      discount.value = 500;
      Get.snackbar(
        'Coupon Applied! 🎉',
        '৳500 discount added',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Invalid Coupon',
        'Please enter a valid coupon code',
        backgroundColor: AppColors.sale,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void proceedToCheckout() => Get.toNamed(AppRoutes.checkout);

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxDouble discount = 0.0.obs;

  final TextEditingController couponController =
  TextEditingController();

  final double deliveryFee = 80.0;

  int get itemCount => cartItems.length;

  double get subtotal {
    return cartItems.fold(
      0.0,
          (sum, item) => sum + item.totalPrice,
    );
  }

  double get total {
    final value = subtotal + deliveryFee - discount.value;
    return value < 0 ? 0.0 : value;
  }

  void addToCart(
      ProductModel product, {
        String color = '',
        String size = '',
        int qty = 1,
      }) {
    if (qty <= 0) return;

    final index = cartItems.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index != -1) {
      final existing = cartItems[index];

      cartItems[index] = CartItemModel(
        product: existing.product,
        quantity: existing.quantity + qty,
        selectedColor: existing.selectedColor,
        selectedSize: existing.selectedSize,
      );
    } else {
      cartItems.add(
        CartItemModel(
          product: product,
          quantity: qty,
          selectedColor: color,
          selectedSize: size,
        ),
      );
    }

    cartItems.refresh();
  }

  void increaseQty(int index) {
    if (index < 0 || index >= cartItems.length) return;

    final item = cartItems[index];

    cartItems[index] = CartItemModel(
      product: item.product,
      quantity: item.quantity + 1,
      selectedColor: item.selectedColor,
      selectedSize: item.selectedSize,
    );

    cartItems.refresh();
  }

  void decreaseQty(int index) {
    if (index < 0 || index >= cartItems.length) return;

    final item = cartItems[index];

    if (item.quantity <= 1) return;

    cartItems[index] = CartItemModel(
      product: item.product,
      quantity: item.quantity - 1,
      selectedColor: item.selectedColor,
      selectedSize: item.selectedSize,
    );

    cartItems.refresh();
  }

  void removeItem(int index) {
    if (index < 0 || index >= cartItems.length) return;

    cartItems.removeAt(index);
    cartItems.refresh();
  }

  void clearCart() {
    cartItems.clear();
    discount.value = 0.0;
    couponController.clear();
  }

  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();

    if (code == 'PINKORA50') {
      discount.value = 500.0;

      Get.snackbar(
        'Coupon Applied! 🎉',
        '৳500 discount added',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } else {
      discount.value = 0.0;

      Get.snackbar(
        'Invalid Coupon',
        'Please enter a valid coupon code',
        backgroundColor: AppColors.sale,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart is Empty',
        'Please add a product before checkout',
        backgroundColor: AppColors.sale,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.toNamed(AppRoutes.checkout);
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
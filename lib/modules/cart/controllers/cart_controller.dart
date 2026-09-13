import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxDouble discount = 0.0.obs;
  final couponController = TextEditingController();
  final double deliveryFee = 80.0;

  int get itemCount => cartItems.length;

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get total {
    final computedTotal = subtotal + deliveryFee - discount.value;
    return computedTotal < 0 ? 0 : computedTotal;
  }

  void addToCart(
      ProductModel product, {
        String color = '',
        String size = '',
        int qty = 1,
      }) {
    final index = cartItems.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      final existingItem = cartItems[index];
      cartItems[index] = CartItemModel(
        product: existingItem.product,
        quantity: existingItem.quantity + qty,
        selectedColor: existingItem.selectedColor,
        selectedSize: existingItem.selectedSize,
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
  }

  void increaseQty(int index) {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      cartItems[index] = CartItemModel(
        product: item.product,
        quantity: item.quantity + 1,
        selectedColor: item.selectedColor,
        selectedSize: item.selectedSize,
      );
    }
  }

  void decreaseQty(int index) {
    if (index >= 0 && index < cartItems.length && cartItems[index].quantity > 1) {
      final item = cartItems[index];
      cartItems[index] = CartItemModel(
        product: item.product,
        quantity: item.quantity - 1,
        selectedColor: item.selectedColor,
        selectedSize: item.selectedSize,
      );
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
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
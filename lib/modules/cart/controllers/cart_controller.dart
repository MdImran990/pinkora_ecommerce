import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_model.dart';
import '../../../app/routes/app_routes.dart';

class CartController extends GetxController {
  // CART ITEMS

  final ValueNotifier<List<CartItemModel>> cartItems =
  ValueNotifier<List<CartItemModel>>([]);

  // COUPON

  final TextEditingController couponController =
  TextEditingController();

  double discount = 0.0;

  final double deliveryFee = 80.0;

  // PRICE

  double get subtotal {
    return cartItems.value.fold(
      0.0,
          (sum, item) => sum + item.totalPrice,
    );
  }

  double get total {
    final result = subtotal + deliveryFee - discount;

    if (result < 0) {
      return 0;
    }

    return result;
  }

  // =========================================================
  // TOTAL ITEM COUNT
  // =========================================================

  int get itemCount {
    return cartItems.value.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  // ADD TO CART

  void addToCart(
      ProductModel product, {
        String color = '',
        String size = '',
        int qty = 1,
      }) {
    final List<CartItemModel> list = [
      ...cartItems.value,
    ];

    final int index = list.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      final oldItem = list[index];

      list[index] = CartItemModel(
        product: oldItem.product,
        quantity: oldItem.quantity + qty,
        selectedColor: oldItem.selectedColor,
        selectedSize: oldItem.selectedSize,
      );
    } else {
      list.add(
        CartItemModel(
          product: product,
          quantity: qty,
          selectedColor: color,
          selectedSize: size,
        ),
      );
    }

    // Update ValueNotifier
    cartItems.value = list;

    // IMPORTANT:
    // No Get.snackbar here.
    // Snackbar/overlay removed to prevent touch blocking.
  }

  // INCREASE QUANTITY

  void increaseQty(int index) {
    final List<CartItemModel> list = [
      ...cartItems.value,
    ];

    if (index < 0 || index >= list.length) {
      return;
    }

    final item = list[index];

    list[index] = CartItemModel(
      product: item.product,
      quantity: item.quantity + 1,
      selectedColor: item.selectedColor,
      selectedSize: item.selectedSize,
    );

    cartItems.value = list;
  }

  // DECREASE QUANTITY

  void decreaseQty(int index) {
    final List<CartItemModel> list = [
      ...cartItems.value,
    ];

    if (index < 0 || index >= list.length) {
      return;
    }

    final item = list[index];

    if (item.quantity <= 1) {
      return;
    }

    list[index] = CartItemModel(
      product: item.product,
      quantity: item.quantity - 1,
      selectedColor: item.selectedColor,
      selectedSize: item.selectedSize,
    );

    cartItems.value = list;
  }

  // =========================================================
  // REMOVE ITEM
  // =========================================================

  void removeItem(int index) {
    final List<CartItemModel> list = [
      ...cartItems.value,
    ];

    if (index < 0 || index >= list.length) {
      return;
    }

    list.removeAt(index);

    cartItems.value = list;
  }

  // =========================================================
  // CLEAR CART
  // =========================================================

  void clearCart() {
    cartItems.value = [];
    discount = 0.0;
    couponController.clear();
  }

  // =========================================================
  // COUPON
  // =========================================================

  void applyCoupon() {
    final String code =
    couponController.text.trim().toUpperCase();

    if (code == 'PINKORA50') {
      discount = 500.0;

      // No snackbar.
      return;
    }

    discount = 0.0;

    // No snackbar.
  }

  // CHECKOUT

  void proceedToCheckout() {
    if (cartItems.value.isEmpty) {
      return;
    }

    Get.toNamed(AppRoutes.checkout);
  }

  // DISPOSE
  @override
  void onClose() {
    cartItems.dispose();
    couponController.dispose();

    super.onClose();
  }
}
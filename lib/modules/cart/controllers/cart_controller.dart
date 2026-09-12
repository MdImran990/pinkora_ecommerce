import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class CartController extends GetxController {
  final _box = GetStorage();
  final cartItems = <CartItemModel>[].obs;
  final couponController = TextEditingController();
  final discount = 0.0.obs;
  final double deliveryFee = 80.0;

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal + deliveryFee - discount.value;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  // ── Storage ──
  void _saveToStorage() {
    final data = cartItems.map((item) => {
      'id': item.product.id,
      'name': item.product.name,
      'price': item.product.price,
      'originalPrice': item.product.originalPrice,
      'discountPercent': item.product.discountPercent,
      'rating': item.product.rating,
      'reviewCount': item.product.reviewCount,
      'category': item.product.category,
      'image': item.product.image,
      'quantity': item.quantity,
      'selectedColor': item.selectedColor,
      'selectedSize': item.selectedSize,
    }).toList();
    _box.write('cart_items', jsonEncode(data));
  }

  void _loadFromStorage() {
    final raw = _box.read<String>('cart_items');
    if (raw != null && raw.isNotEmpty) {
      try {
        final List list = jsonDecode(raw);
        cartItems.value = list.map((e) => CartItemModel(
          product: ProductModel(
            id: e['id'],
            name: e['name'],
            image: e['image'] ?? '',
            price: (e['price'] as num).toDouble(),
            originalPrice: (e['originalPrice'] as num).toDouble(),
            discountPercent: e['discountPercent'],
            rating: (e['rating'] as num).toDouble(),
            reviewCount: e['reviewCount'],
            category: e['category'],
          ),
          quantity: e['quantity'],
          selectedColor: e['selectedColor'] ?? '',
          selectedSize: e['selectedSize'] ?? '',
        )).toList();
      } catch (_) {
        cartItems.clear();
      }
    }
  }

  // ── Add to Cart ──
  void addToCart(ProductModel product,
      {String color = '', String size = '', int qty = 1}) {
    final index =
    cartItems.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity += qty;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(
        product: product,
        quantity: qty,
        selectedColor: color,
        selectedSize: size,
      ));
    }
    _saveToStorage();
    Get.snackbar(
      'Added to Cart! 🛒',
      '${product.name} added successfully',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 1),
    );
  }

  void increaseQty(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
    _saveToStorage();
  }

  void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
      _saveToStorage();
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
    _saveToStorage();
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

  void clearCart() {
    cartItems.clear();
    _box.remove('cart_items');
  }

  void proceedToCheckout() => Get.toNamed(AppRoutes.checkout);
}
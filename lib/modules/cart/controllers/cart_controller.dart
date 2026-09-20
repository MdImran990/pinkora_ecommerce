import 'dart:math' as math;

import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../widgets/custom_snackbar.dart';

class CartController extends GetxController {
  final CartRepository _repo = Get.find<CartRepository>();

  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  /// Applied coupon code ('' = none).
  final RxString couponCode = ''.obs;

  static const double standardDeliveryFee = 80.0;

  // Demo coupons (real validation comes with the backend).
  static const Map<String, double> _fixedCoupons = {
    'PINKORA50': 500.0,
  };

  static const Map<String, double> _percentCoupons = {
    'WELCOME10': 10.0,
  };

  @override
  void onInit() {
    super.onInit();
    cartItems.assignAll(_repo.load());
  }

  // ── Totals (only checked items count) ──

  int get itemCount => cartItems.length;

  List<CartItemModel> get selectedItems {
    return cartItems.where((item) => item.isSelected).toList();
  }

  bool get hasSelection => cartItems.any((item) => item.isSelected);

  bool get isAllSelected {
    return cartItems.isNotEmpty &&
        cartItems.every((item) => item.isSelected);
  }

  double get subtotal {
    double sum = 0.0;

    for (final item in cartItems) {
      if (item.isSelected) sum += item.totalPrice;
    }

    return sum;
  }

  double get deliveryFee => hasSelection ? standardDeliveryFee : 0.0;

  double get discountAmount {
    final code = couponCode.value;
    final sub = subtotal;

    if (code.isEmpty || sub <= 0) return 0.0;

    final fixed = _fixedCoupons[code];

    if (fixed != null) return math.min(fixed, sub);

    final percent = _percentCoupons[code];

    if (percent != null) return (sub * percent / 100).roundToDouble();

    return 0.0;
  }

  double get total {
    final value = subtotal + deliveryFee - discountAmount;
    return value < 0 ? 0.0 : value;
  }

  // ── Items ──

  void addToCart(
      ProductModel product, {
        String color = '',
        String size = '',
        int qty = 1,
      }) {
    if (qty <= 0) return;

    final key = CartItemModel.keyOf(product.id, color, size);
    final index = cartItems.indexWhere((item) => item.key == key);

    if (index != -1) {
      final existing = cartItems[index];

      cartItems[index] = existing.copyWith(
        quantity: existing.quantity + qty,
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

    _persist();
  }

  void increaseQty(int index) {
    if (index < 0 || index >= cartItems.length) return;

    final item = cartItems[index];

    cartItems[index] = item.copyWith(quantity: item.quantity + 1);

    _persist();
  }

  void decreaseQty(int index) {
    if (index < 0 || index >= cartItems.length) return;

    final item = cartItems[index];

    if (item.quantity <= 1) return;

    cartItems[index] = item.copyWith(quantity: item.quantity - 1);

    _persist();
  }

  void removeItem(int index) {
    if (index < 0 || index >= cartItems.length) return;

    cartItems.removeAt(index);

    _persist();
  }

  void toggleSelect(int index) {
    if (index < 0 || index >= cartItems.length) return;

    final item = cartItems[index];

    cartItems[index] = item.copyWith(isSelected: !item.isSelected);

    _persist();
  }

  /// Used by "Buy Now": only this product goes to checkout.
  void selectOnly(String productId, String color, String size) {
    final key = CartItemModel.keyOf(productId, color, size);

    cartItems.assignAll(
      cartItems
          .map((item) => item.copyWith(isSelected: item.key == key))
          .toList(),
    );

    _persist();
  }

  /// Removes the ordered (checked) items and resets the coupon.
  void removeSelected() {
    cartItems.removeWhere((item) => item.isSelected);
    couponCode.value = '';

    _persist();
  }

  void clearCart() {
    cartItems.clear();
    couponCode.value = '';

    _persist();
  }

  // ── Coupon ──

  bool applyCoupon(String raw) {
    final code = raw.trim().toUpperCase();

    if (code.isEmpty) {
      CustomSnackbar.error(
        'Coupon Required',
        'Please enter a coupon code',
      );
      return false;
    }

    if (!hasSelection) {
      CustomSnackbar.error(
        'No Items Selected',
        'Select at least one item to use a coupon',
      );
      return false;
    }

    if (_fixedCoupons.containsKey(code)) {
      couponCode.value = code;

      CustomSnackbar.success(
        'Coupon Applied! 🎉',
        '৳${_fixedCoupons[code]!.toInt()} discount added',
      );
      return true;
    }

    if (_percentCoupons.containsKey(code)) {
      couponCode.value = code;

      CustomSnackbar.success(
        'Coupon Applied! 🎉',
        '${_percentCoupons[code]!.toInt()}% discount added',
      );
      return true;
    }

    couponCode.value = '';

    CustomSnackbar.error(
      'Invalid Coupon',
      'Please enter a valid coupon code',
    );
    return false;
  }

  void removeCoupon() {
    couponCode.value = '';
  }

  // ── Checkout ──

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      CustomSnackbar.error(
        'Cart is Empty',
        'Please add a product before checkout',
      );
      return;
    }

    if (!hasSelection) {
      CustomSnackbar.error(
        'No Items Selected',
        'Please select at least one item',
      );
      return;
    }

    Get.toNamed(AppRoutes.checkout);
  }

  void _persist() {
    _repo.save(cartItems.toList());
  }
}

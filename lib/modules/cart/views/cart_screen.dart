import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/coupon_input_field.dart';
import '../../../app/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        title: Obx(() => Text(
          'My Cart (${controller.cartItems.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                if (controller.cartItems.isNotEmpty) {
                  controller.cartItems.clear();
                }
              },
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add items to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Shop Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // ── Cart Items List ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                itemCount: controller.cartItems.length,
                itemBuilder: (_, i) {
                  return Obx(() => CartItemTile(
                    item: controller.cartItems[i],
                    index: i,
                    onIncrease: () => controller.increaseQty(i),
                    onDecrease: () => controller.decreaseQty(i),
                    onRemove: () => controller.removeItem(i),
                  ));
                },
              ),
            ),

            // ── Bottom Summary ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Coupon
                  CouponInputField(
                    controller: controller.couponController,
                    onApply: controller.applyCoupon,
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),

                  // Price breakdown
                  Obx(() => Column(
                    children: [
                      _PriceRow(
                        label: 'Subtotal',
                        value: '৳ ${controller.subtotal.toInt()}',
                      ),
                      const SizedBox(height: 8),
                      _PriceRow(
                        label: 'Delivery Fee',
                        value: '৳ ${controller.deliveryFee.toInt()}',
                      ),
                      if (controller.discount.value > 0) ...[
                        const SizedBox(height: 8),
                        _PriceRow(
                          label: 'Discount',
                          value:
                          '- ৳ ${controller.discount.value.toInt()}',
                          valueColor: AppColors.success,
                        ),
                      ],
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 12),
                      _PriceRow(
                        label: 'Total',
                        value: '৳ ${controller.total.toInt()}',
                        isBold: true,
                      ),
                    ],
                  )),

                  const SizedBox(height: 16),

                  // Checkout button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.proceedToCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const PinkoraBottomNav(),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight:
            isBold ? FontWeight.w700 : FontWeight.w400,
            color: AppColors.darkGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight:
            isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ??
                (isBold ? AppColors.black : AppColors.darkGrey),
          ),
        ),
      ],
    );
  }
}
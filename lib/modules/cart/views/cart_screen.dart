import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/bottom_nav_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.offAllNamed(AppRoutes.home),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.black,
            ),
          ),
        ),
        title: ValueListenableBuilder(
          valueListenable: ctrl.cartItems,
          builder: (_, items, __) => Text(
            'My Cart (${items.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: ctrl.clearCart,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: ctrl.cartItems,
        builder: (context, items, _) {
          if (items.isEmpty) {
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
                    onPressed: () =>
                        Get.offAllNamed(AppRoutes.home),
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
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(
                                right: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                              BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.primary
                                  .withValues(alpha: 0.5),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product.name,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight:
                                          FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow
                                            .ellipsis,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          ctrl.removeItem(i),
                                      child: const Icon(
                                        Icons
                                            .delete_outline_rounded,
                                        color: AppColors.grey,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.selectedSize.isNotEmpty)
                                  Text(item.selectedSize,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.grey))
                                else if (
                                item.selectedColor.isNotEmpty)
                                  Text(item.selectedColor,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.grey)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              ctrl.decreaseQty(i),
                                          child: Container(
                                            width: 26,
                                            height: 26,
                                            decoration:
                                            BoxDecoration(
                                              color: item.quantity <=
                                                  1
                                                  ? AppColors
                                                  .lightGrey
                                                  : AppColors
                                                  .primaryLight,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(7),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              size: 14,
                                              color: item.quantity <=
                                                  1
                                                  ? AppColors.grey
                                                  : AppColors
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '${item.quantity}',
                                            style:
                                            const TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w700,
                                              color:
                                              AppColors.black,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              ctrl.increaseQty(i),
                                          child: Container(
                                            width: 26,
                                            height: 26,
                                            decoration:
                                            BoxDecoration(
                                              color: AppColors
                                                  .primaryLight,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(7),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              size: 14,
                                              color:
                                              AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '৳ ${item.totalPrice.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                const EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ctrl.couponController,
                            decoration: InputDecoration(
                              hintText: 'Apply Coupon Code',
                              hintStyle: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 13,
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: ctrl.applyCoupon,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 8),
                    _PriceRow(
                      label: 'Subtotal',
                      value: '৳ ${ctrl.subtotal.toInt()}',
                    ),
                    const SizedBox(height: 6),
                    _PriceRow(
                      label: 'Delivery Fee',
                      value: '৳ ${ctrl.deliveryFee.toInt()}',
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 8),
                    _PriceRow(
                      label: 'Total',
                      value: '৳ ${ctrl.total.toInt()}',
                      isBold: true,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: ctrl.proceedToCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
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
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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
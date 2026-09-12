import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/color_selector.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/rating_row.dart';
import '../../../app/theme/app_colors.dart';

class ProductDetailScreen extends GetView<ProductController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Obx(() {
        final p = controller.product.value;
        if (p == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return CustomScrollView(
          slivers: [
            // ── APP BAR ──
            SliverAppBar(
              backgroundColor: AppColors.scaffoldBg,
              elevation: 0,
              pinned: true,
              leading: GestureDetector(
                onTap: () => Get.back(),
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
                      color: AppColors.black),
                ),
              ),
              actions: [
                Obx(() => GestureDetector(
                  onTap: controller.toggleWishlist,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(
                      controller.isWishlisted.value
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: controller.isWishlisted.value
                          ? AppColors.primary
                          : AppColors.grey,
                      size: 20,
                    ),
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.share_outlined,
                      size: 20, color: AppColors.black),
                ),
              ],
            ),

            // ── IMAGE ──
            const SliverToBoxAdapter(
              child: ProductImageGallery(),
            ),

            // ── INFO ──
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black)),

                    const SizedBox(height: 8),

                    // Rating
                    RatingRow(
                        rating: p.rating,
                        reviewCount: p.reviewCount),

                    const SizedBox(height: 14),

                    // Price
                    Row(
                      children: [
                        Text('৳ ${p.price.toInt()}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary)),
                        const SizedBox(width: 10),
                        Text('৳ ${p.originalPrice.toInt()}',
                            style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.grey,
                                decoration:
                                TextDecoration.lineThrough,
                                decorationColor: AppColors.grey)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${p.discountPercent}% OFF',
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 16),

                    // Color
                    if (p.colors.isNotEmpty) ...[
                      const Text('Color',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black)),
                      const SizedBox(height: 10),
                      Obx(() => ColorSelector(
                        colors: p.colors,
                        selectedColor:
                        controller.selectedColor.value,
                        onSelect: controller.selectColor,
                      )),
                      const SizedBox(height: 16),
                    ],

                    // Quantity
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black)),
                        Obx(() => QuantityStepper(
                          quantity: controller.quantity.value,
                          onIncrease: controller.increaseQty,
                          onDecrease: controller.decreaseQty,
                        )),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.addToCart,
                            icon: const Icon(
                                Icons.shopping_cart_outlined,
                                size: 18),
                            label: const Text('Add to Cart'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(30)),
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.buyNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(30)),
                              elevation: 0,
                            ),
                            child: const Text('Buy Now',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
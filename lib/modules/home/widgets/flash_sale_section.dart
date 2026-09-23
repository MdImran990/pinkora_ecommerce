import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/model/product_model.dart';
import 'product_card_home.dart';
import '../../../widgets/staggered_fade_in.dart';

class FlashSaleSection extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback onSeeAll;

  const FlashSaleSection({
    super.key,
    required this.products,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── SECTION HEADER ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Flash Sale',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── PRODUCTS ──
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            cacheExtent: 500,
            itemCount: products.length,
            separatorBuilder: (_, __) =>
            const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return StaggeredFadeIn(
                index: index,
                direction: AxisDirection.right,
                child: ProductCardHome(
                  key: ValueKey(products[index].id),
                  product: products[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
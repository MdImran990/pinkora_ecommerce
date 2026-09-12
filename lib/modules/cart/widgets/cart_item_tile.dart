import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/model/cart_item_model.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final int index;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(Icons.check_rounded,
                color: Colors.white, size: 13),
          ),

          // Image
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.shopping_bag_outlined,
                color: AppColors.primary.withValues(alpha: 0.5),
                size: 34),
          ),

          const SizedBox(width: 10),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.grey,
                          size: 18),
                    ),
                  ],
                ),

                if (item.selectedSize.isNotEmpty)
                  Text(item.selectedSize,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.grey))
                else if (item.selectedColor.isNotEmpty)
                  Text(item.selectedColor,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.grey)),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stepper
                    Row(
                      children: [
                        _Btn(
                            icon: Icons.remove,
                            onTap: onDecrease,
                            disabled: item.quantity <= 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Text('${item.quantity}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black)),
                        ),
                        _Btn(icon: Icons.add, onTap: onIncrease),
                      ],
                    ),

                    // Price
                    Text('৳ ${item.totalPrice.toInt()}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool disabled;

  const _Btn({
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.lightGrey
              : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon,
            size: 15,
            color:
            disabled ? AppColors.grey : AppColors.primary),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';
import '../../../app/theme/app_colors.dart';

class DeliveryStep extends StatelessWidget {
  final CheckoutController controller;

  const DeliveryStep({
    super.key,
    required this.controller,
  });

  static const String _standard = 'standard';
  static const String _express = 'express';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 16),

        Obx(
              () {
            final selected =
                controller.selectedDelivery.value;

            return Column(
              children: [
                _DeliveryOption(
                  title: 'Standard Delivery',
                  subtitle: '3-5 business days',
                  price: '৳ 80',
                  value: _standard,
                  groupValue: selected,
                  onTap: () =>
                      controller.selectDelivery(_standard),
                ),

                const SizedBox(height: 12),

                _DeliveryOption(
                  title: 'Express Delivery',
                  subtitle: '1-2 business days',
                  price: '৳ 150',
                  value: _express,
                  groupValue: selected,
                  onTap: () =>
                      controller.selectDelivery(_express),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _DeliveryOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    final borderColor = isSelected
        ? AppColors.primary
        : AppColors.border;

    final textColor = isSelected
        ? AppColors.primary
        : AppColors.black;

    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Radio indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 10,
                      height: 10,
                    ),
                  ),
                )
                    : null,
              ),

              const SizedBox(width: 12),

              // Delivery information
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Price
              Text(
                price,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
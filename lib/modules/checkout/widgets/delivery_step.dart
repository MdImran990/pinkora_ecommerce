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

class _DeliveryOption extends StatefulWidget {
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
  State<_DeliveryOption> createState() =>
      _DeliveryOptionState();
}

class _DeliveryOptionState extends State<_DeliveryOption>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;

  bool get isSelected =>
      widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.0,
      upperBound: 0.025,
    );
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = isSelected;

    final borderColor = selected
        ? AppColors.primary
        : AppColors.border;

    final textColor = selected
        ? AppColors.primary
        : AppColors.black;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 - _pressController.value,
            child: child,
          );
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: selected ? 1.5 : 1,
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.grey,
                      width: 2,
                    ),
                  ),
                  child: AnimatedScale(
                    scale: selected ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOutBack,
                    child: const Center(
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
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Delivery information
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration:
                        const Duration(milliseconds: 160),
                        curve: Curves.easeOutCubic,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        child: Text(widget.title),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  child: Text(widget.price),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
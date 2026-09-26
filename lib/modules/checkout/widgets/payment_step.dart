import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../widgets/payment_badge.dart';

class PaymentStep extends StatelessWidget {
  final CheckoutController controller;

  const PaymentStep({
    super.key,
    required this.controller,
  });

  static const String _bkash = 'bkash';
  static const String _nagad = 'nagad';
  static const String _card = 'card';
  static const String _cod = 'cod';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 16),

        Obx(
              () {
            final selected = controller.selectedPayment.value;

            Widget option(String label, String value) {
              return Expanded(
                child: _PaymentOption(
                  label: label,
                  value: value,
                  groupValue: selected,
                  onTap: () => controller.selectPayment(value),
                ),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    option('bKash', _bkash),
                    const SizedBox(width: 14),
                    option('Nagad', _nagad),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    option('Card Payment', _card),
                    const SizedBox(width: 14),
                    option('Cash on Delivery', _cod),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Payment Option
// ─────────────────────────────────────────────

class _PaymentOption extends StatefulWidget {
  final String label;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  State<_PaymentOption> createState() =>
      _PaymentOptionState();
}

class _PaymentOptionState extends State<_PaymentOption>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;

  bool get isSelected => widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.0,
      upperBound: 0.04,
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

    final backgroundColor = selected ? AppColors.primaryLight : AppColors.white;
    final borderColor = selected ? AppColors.primary : AppColors.border;
    final textColor = selected ? AppColors.primary : AppColors.black;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          // A tiny lift + scale-up when selected, on top of the tap-down
          // press animation, so choosing an option feels tactile.
          final selectedBump = selected ? 1.03 : 1.0;

          return Transform.scale(
            scale: selectedBump - _pressController.value,
            child: child,
          );
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: borderColor,
                width: selected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.18)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: selected ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PaymentBadge(
                      method: widget.value,
                      size: 52,
                      withBackground: false,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 32,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: textColor,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        child: Text(
                          widget.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),

                // Selected check badge - pops in with a springy bounce.
                Positioned(
                  top: -8,
                  right: -8,
                  child: AnimatedScale(
                    scale: selected ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

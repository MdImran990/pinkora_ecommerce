import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';
import '../../../app/theme/app_colors.dart';

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
            final selected =
                controller.selectedPayment.value;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _PaymentOption(
                  label: 'bKash',
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFFE2136E),
                  value: _bkash,
                  groupValue: selected,
                  onTap: () =>
                      controller.selectPayment(_bkash),
                ),

                _PaymentOption(
                  label: 'Nagad',
                  icon: Icons.account_balance_wallet_rounded,
                  color: const Color(0xFFFF6B00),
                  value: _nagad,
                  groupValue: selected,
                  onTap: () =>
                      controller.selectPayment(_nagad),
                ),

                _PaymentOption(
                  label: 'Card Payment',
                  icon: Icons.credit_card_rounded,
                  color: const Color(0xFF3D5AFE),
                  value: _card,
                  groupValue: selected,
                  onTap: () =>
                      controller.selectPayment(_card),
                ),

                _PaymentOption(
                  label: 'Cash on Delivery',
                  icon: Icons.payments_rounded,
                  color: const Color(0xFF4CAF50),
                  value: _cod,
                  groupValue: selected,
                  onTap: () =>
                      controller.selectPayment(_cod),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    final backgroundColor = isSelected
        ? AppColors.primaryLight
        : AppColors.white;

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
          width: (MediaQuery.sizeOf(context).width - 56) / 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
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

              const SizedBox(width: 8),

              Icon(
                icon,
                color: color,
                size: 18,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../../../app/theme/app_colors.dart';

class PaymentStep extends StatelessWidget {
  final CheckoutController controller;

  const PaymentStep({super.key, required this.controller});

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

        Obx(() => Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _PaymentOption(
              label: 'bKash',
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFFE2136E),
              value: 'bkash',
              groupValue: controller.selectedPayment.value,
              onTap: () => controller.selectPayment('bkash'),
            ),
            _PaymentOption(
              label: 'Nagad',
              icon: Icons.account_balance_wallet_rounded,
              color: const Color(0xFFFF6B00),
              value: 'nagad',
              groupValue: controller.selectedPayment.value,
              onTap: () => controller.selectPayment('nagad'),
            ),
            _PaymentOption(
              label: 'Card Payment',
              icon: Icons.credit_card_rounded,
              color: const Color(0xFF3D5AFE),
              value: 'card',
              groupValue: controller.selectedPayment.value,
              onTap: () => controller.selectPayment('card'),
            ),
            _PaymentOption(
              label: 'Cash on Delivery',
              icon: Icons.payments_rounded,
              color: const Color(0xFF4CAF50),
              value: 'cod',
              groupValue: controller.selectedPayment.value,
              onTap: () => controller.selectPayment('cod'),
            ),
          ],
        )),
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
    final w = (MediaQuery.of(context).size.width - 56) / 2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight
              : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
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
                  ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
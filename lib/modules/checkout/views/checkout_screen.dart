import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/checkout_step_indicator.dart';
import '../widgets/address_step.dart';
import '../widgets/delivery_step.dart';
import '../widgets/payment_step.dart';
import '../../../app/theme/app_colors.dart';

class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.black),
          ),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: Obx(() => Column(
        children: [
          // ── Step Indicator ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: CheckoutStepIndicator(
              currentStep: controller.currentStep.value,
            ),
          ),

          const SizedBox(height: 16),

          // ── Step Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildStep(controller.currentStep.value),
            ),
          ),

          // ── Order Summary ──
          if (controller.currentStep.value == 3)
            _OrderSummary(controller: controller),

          // ── Bottom Button ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            color: AppColors.scaffoldBg,
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.currentStep.value == 3
                    ? controller.placeOrder
                    : controller.nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  controller.currentStep.value == 3
                      ? 'Place Order'
                      : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return AddressStep(controller: controller);
      case 1:
        return DeliveryStep(controller: controller);
      case 2:
        return PaymentStep(controller: controller);
      case 3:
        return _ConfirmStep(controller: controller);
      default:
        return const SizedBox();
    }
  }
}

// ── Confirm Step ──
class _ConfirmStep extends StatelessWidget {
  final CheckoutController controller;

  const _ConfirmStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 16),

        // Address
        _SummaryCard(
          title: 'Shipping Address',
          icon: Icons.location_on_rounded,
          content: controller.addressController.text,
        ),
        const SizedBox(height: 12),

        // Delivery
        Obx(() => _SummaryCard(
          title: 'Delivery Method',
          icon: Icons.local_shipping_rounded,
          content: controller.selectedDelivery.value == 'standard'
              ? 'Standard Delivery (3-5 days) — ৳ 80'
              : 'Express Delivery (1-2 days) — ৳ 150',
        )),
        const SizedBox(height: 12),

        // Payment
        Obx(() => _SummaryCard(
          title: 'Payment Method',
          icon: Icons.payment_rounded,
          content: _paymentLabel(controller.selectedPayment.value),
        )),

        const SizedBox(height: 80),
      ],
    );
  }

  String _paymentLabel(String val) {
    switch (val) {
      case 'bkash':  return 'bKash';
      case 'nagad':  return 'Nagad';
      case 'card':   return 'Card Payment';
      case 'cod':    return 'Cash on Delivery';
      default:       return val;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _SummaryCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order Summary Bottom ──
class _OrderSummary extends StatelessWidget {
  final CheckoutController controller;

  const _OrderSummary({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _Row('Subtotal',
              '৳ ${controller.subtotal.toInt()}'),
          const SizedBox(height: 6),
          _Row('Delivery Fee',
              '৳ ${controller.deliveryFee.toInt()}'),
          const SizedBox(height: 6),
          _Row('Discount',
              '- ৳ ${controller.discount.toInt()}',
              valueColor: AppColors.success),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: AppColors.border),
          ),
          _Row('Total',
              '৳ ${controller.total.toInt()}',
              isBold: true),
        ],
      ),
    ));
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _Row(this.label, this.value,
      {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w400,
              color: AppColors.darkGrey,
            )),
        Text(value,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ??
                  (isBold ? AppColors.black : AppColors.darkGrey),
            )),
      ],
    );
  }
}
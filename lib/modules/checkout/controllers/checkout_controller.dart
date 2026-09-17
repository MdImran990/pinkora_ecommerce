import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

class CheckoutController extends GetxController {
  final RxInt currentStep = 0.obs;

  // Address
  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController addressController =
  TextEditingController();

  // Delivery
  final RxString selectedDelivery = 'standard'.obs;

  static const double standardFee = 80.0;
  static const double expressFee = 150.0;

  double get deliveryFee {
    return selectedDelivery.value == 'standard'
        ? standardFee
        : expressFee;
  }

  // Payment
  final RxString selectedPayment = 'bkash'.obs;

  // Order values
  static const double subtotal = 9800.0;
  static const double discount = 500.0;

  double get total {
    final value = subtotal + deliveryFee - discount;
    return value < 0 ? 0.0 : value;
  }

  @override
  void onInit() {
    super.onInit();

    nameController.text = 'Imran Hossain';
    phoneController.text = '01700000000';
    addressController.text =
    'House 12, Road 5, Dhanmondi, Dhaka, 1205';
  }

  void nextStep() {
    final step = currentStep.value;

    if (step >= 3) return;

    currentStep.value = step + 1;
  }

  void previousStep() {
    final step = currentStep.value;

    if (step <= 0) return;

    currentStep.value = step - 1;
  }

  void selectDelivery(String type) {
    if (selectedDelivery.value == type) return;

    selectedDelivery.value = type;
  }

  void selectPayment(String method) {
    if (selectedPayment.value == method) return;

    selectedPayment.value = method;
  }

  void placeOrder() {
    Get.offAllNamed(AppRoutes.home);

    Get.snackbar(
      'Order Placed! 🎉',
      'Your order has been placed successfully',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    super.onClose();
  }
}
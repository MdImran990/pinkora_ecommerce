import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class CheckoutController extends GetxController {
  final currentStep = 0.obs;

  // Address
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Delivery
  final selectedDelivery = 'standard'.obs;
  final double standardFee = 80;
  final double expressFee = 150;

  double get deliveryFee =>
      selectedDelivery.value == 'standard' ? standardFee : expressFee;

  // Payment
  final selectedPayment = 'bkash'.obs;

  final subtotal = 9800.0;
  final discount = 500.0;

  double get total => subtotal + deliveryFee - discount;

  @override
  void onInit() {
    super.onInit();
    // prefill dummy address
    nameController.text = 'Imran Hossain';
    phoneController.text = '01700000000';
    addressController.text = 'House 12, Road 5, Dhanmondi, Dhaka, 1205';
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void selectDelivery(String type) => selectedDelivery.value = type;
  void selectPayment(String method) => selectedPayment.value = method;

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
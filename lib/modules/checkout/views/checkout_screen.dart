import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(child: Text('Checkout Screen - Coming Soon')),
    );
  }
}
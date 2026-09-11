import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep;

  const CheckoutStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Address', 'Delivery', 'Payment', 'Confirm'];
    final icons = [
      Icons.location_on_rounded,
      Icons.local_shipping_rounded,
      Icons.payment_rounded,
      Icons.check_circle_rounded,
    ];

    return Row(
      children: List.generate(steps.length, (i) {
        final isActive = i == currentStep;
        final isDone = i < currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isActive || isDone
                            ? AppColors.primary
                            : AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icons[i],
                        size: 18,
                        color: isActive || isDone
                            ? Colors.white
                            : AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps[i],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: i < currentStep
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final isMinimum = quantity <= 1;

    return Row(
      children: [
        _StepBtn(
          icon: Icons.remove,
          onTap: onDecrease,
          isDisabled: isMinimum,
        ),
        const SizedBox(width: 16),
        Text(
          '$quantity',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(width: 16),
        _StepBtn(
          icon: Icons.add,
          onTap: onIncrease,
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;

  const _StepBtn({
    required this.icon,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor =
    isDisabled ? AppColors.lightGrey : AppColors.primaryLight;

    final iconColor =
    isDisabled ? AppColors.grey : AppColors.primary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isDisabled ? null : onTap,
      child: RepaintBoundary(
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
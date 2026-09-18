import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class CheckoutStepIndicator extends StatelessWidget {
  final int currentStep;

  const CheckoutStepIndicator({
    super.key,
    required this.currentStep,
  });

  static const List<String> _steps = [
    'Address',
    'Delivery',
    'Payment',
    'Confirm',
  ];

  static const List<IconData> _icons = [
    Icons.location_on_rounded,
    Icons.local_shipping_rounded,
    Icons.payment_rounded,
    Icons.check_circle_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        _steps.length,
            (index) {
          final isActive = index == currentStep;
          final isDone = index < currentStep;
          final isCompleted = isActive || isDone;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _StepItem(
                    label: _steps[index],
                    icon: _icons[index],
                    isActive: isActive,
                    isCompleted: isCompleted,
                  ),
                ),

                if (index < _steps.length - 1)
                  Expanded(
                    child: _StepConnector(
                      isCompleted: index < currentStep,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Step Item
// ─────────────────────────────────────────────

class _StepItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isCompleted;

  const _StepItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.primary
                  : AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (
                  child,
                  animation,
                  ) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Icon(
                icon,
                key: ValueKey(
                  '$icon-$isCompleted',
                ),
                size: 18,
                color: isCompleted
                    ? Colors.white
                    : AppColors.grey,
              ),
            ),
          ),

          const SizedBox(height: 4),

          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: isActive
                  ? AppColors.primary
                  : AppColors.grey,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Step Connector
// ─────────────────────────────────────────────

class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        color: isCompleted
            ? AppColors.primary
            : AppColors.border,
      ),
    );
  }
}
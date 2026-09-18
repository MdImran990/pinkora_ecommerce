import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class CouponInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onApply;

  const CouponInputField({
    super.key,
    required this.controller,
    required this.onApply,
  });

  static OutlineInputBorder _border({
    Color color = AppColors.border,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RepaintBoundary(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onApply(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Apply Coupon Code',
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _border(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _AnimatedApplyButton(
          onTap: onApply,
        ),
      ],
    );
  }
}

class _AnimatedApplyButton extends StatefulWidget {
  const _AnimatedApplyButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_AnimatedApplyButton> createState() =>
      _AnimatedApplyButtonState();
}

class _AnimatedApplyButtonState
    extends State<_AnimatedApplyButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapCancel() {
    _controller.reverse();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _tapDown,
      onTapCancel: _tapCancel,
      onTapUp: _tapUp,
      child: ScaleTransition(
        scale: _scale,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
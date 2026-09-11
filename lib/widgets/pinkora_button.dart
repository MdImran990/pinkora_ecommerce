import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class PinkoraButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;
  final bool isLoading;
  final double? width;

  const PinkoraButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: isOutlined
          ? OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
              color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _child(),
      )
          : ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: _child(),
      ),
    );
  }

  Widget _child() {
    if (isLoading) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5,
        ),
      );
    }
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isOutlined ? AppColors.primary : Colors.white,
      ),
    );
  }
}
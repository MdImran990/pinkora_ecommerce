import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class PinkoraTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;

  const PinkoraTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.grey, size: 20)
            : null,
      ),
    );
  }
}
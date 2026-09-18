import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.isPasswordHidden = true,
    this.onTogglePassword,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isPasswordHidden;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && isPasswordHidden,
      validator: validator,

      // Keeps keyboard behavior smooth.
      textInputAction: isPassword
          ? TextInputAction.done
          : TextInputAction.next,

      style: const TextStyle(
        fontSize: 14,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
      ),

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: const Icon(
          Icons.person_outline_rounded,
          color: AppColors.grey,
          size: 20,
        ),

        suffixIcon: isPassword
            ? IconButton(
          tooltip: 'Show password',
          onPressed: onTogglePassword,
          splashRadius: 22,
          icon: Icon(
            isPasswordHidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.grey,
            size: 20,
          ),
        )
            : null,
      ),
    );
  }
}
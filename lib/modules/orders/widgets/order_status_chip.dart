import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/model/order_model.dart';

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({
    super.key,
    required this.order,
  });

  final OrderModel order;

  ({Color fg, Color bg}) _colors() {
    switch (order.status) {
      case OrderStatus.shipped:
        return (fg: const Color(0xFF3D5AFE), bg: const Color(0xFFE8EAFF));
      case OrderStatus.delivered:
        return (fg: AppColors.success, bg: const Color(0xFFE8F5E9));
      case OrderStatus.cancelled:
        return (fg: AppColors.error, bg: const Color(0xFFFFEBEE));
      default:
        return (fg: const Color(0xFFFF9800), bg: const Color(0xFFFFF3E0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        order.statusLabel,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.fg,
        ),
      ),
    );
  }
}

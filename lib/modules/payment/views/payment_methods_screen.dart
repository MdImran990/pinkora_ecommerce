import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/pinkora_app_bar.dart';

/// Choose the payment method that is pre-selected at checkout.
/// Real payment (bKash / Nagad / card gateway) is connected with the backend.
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  static const _methods = <_Method>[
    _Method(
      id: 'bkash',
      title: 'bKash',
      subtitle: 'Pay with your bKash account',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFFE2136E),
    ),
    _Method(
      id: 'nagad',
      title: 'Nagad',
      subtitle: 'Pay with your Nagad account',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFFF6921E),
    ),
    _Method(
      id: 'card',
      title: 'Card Payment',
      subtitle: 'Visa, Mastercard and other cards',
      icon: Icons.credit_card_rounded,
      color: Color(0xFF3D5AFE),
    ),
    _Method(
      id: 'cod',
      title: 'Cash on Delivery',
      subtitle: 'Pay when you receive the order',
      icon: Icons.payments_rounded,
      color: Color(0xFF4CAF50),
    ),
  ];

  final GetStorage _box = GetStorage();

  late String _selected;

  @override
  void initState() {
    super.initState();

    _selected =
        _box.read<String>(StorageKeys.defaultPayment) ?? 'bkash';
  }

  Future<void> _select(String id) async {
    setState(() => _selected = id);

    await _box.write(StorageKeys.defaultPayment, id);

    CustomSnackbar.success(
      'Default Updated',
      'This method will be pre-selected at checkout',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: pinkoraAppBar('Payment Methods'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            'Default payment method',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          for (final method in _methods)
            GestureDetector(
              onTap: () => _select(method.id),
              child: AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                borderColor:
                method.id == _selected ? AppColors.primary : null,
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: method.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        method.icon,
                        color: method.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            method.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      method.id == _selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: method.id == _selected
                          ? AppColors.primary
                          : AppColors.grey,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Online payment is not active yet. Your choice is saved '
                        'as the default and will be used when payments are '
                        'connected.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGrey,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Method {
  const _Method({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

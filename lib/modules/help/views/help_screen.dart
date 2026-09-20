import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/pinkora_app_bar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  // Change these to your real support details.
  static const String supportPhone = '+880 1700-000000';
  static const String supportEmail = 'support@pinkora.com';
  static const String supportHours = 'Every day, 9:00 AM - 9:00 PM';

  static const List<_Faq> _faqs = [
    _Faq(
      question: 'How do I place an order?',
      answer:
      'Add products to your cart, tap Proceed to Checkout, choose your '
          'address, delivery and payment method, then confirm the order.',
    ),
    _Faq(
      question: 'How long does delivery take?',
      answer:
      'Standard delivery takes 3-5 business days and Express delivery '
          'takes 1-2 business days.',
    ),
    _Faq(
      question: 'Which payment methods are available?',
      answer:
      'bKash, Nagad, card payment and Cash on Delivery are supported.',
    ),
    _Faq(
      question: 'Can I cancel my order?',
      answer:
      'Yes. Open My Orders, choose the order and tap Cancel Order. '
          'Orders can be cancelled while they are still Processing.',
    ),
    _Faq(
      question: 'How do I use a coupon?',
      answer:
      'Enter the coupon code in your cart and tap Apply. The discount '
          'is added to your total automatically.',
    ),
  ];

  Future<void> _copy(String label, String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    CustomSnackbar.success('Copied', '$label copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: pinkoraAppBar('Help & Support'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          const Text(
            'Frequently asked questions',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          for (final faq in _faqs)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                  childrenPadding:
                  const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.grey,
                  title: Text(
                    faq.question,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  children: [
                    Text(
                      faq.answer,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Contact us',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          _ContactTile(
            icon: Icons.phone_rounded,
            title: 'Call us',
            value: supportPhone,
            onTap: () => _copy('Phone number', supportPhone),
          ),
          const SizedBox(height: 10),
          _ContactTile(
            icon: Icons.email_rounded,
            title: 'Email us',
            value: supportEmail,
            onTap: () => _copy('Email address', supportEmail),
          ),
          const SizedBox(height: 10),
          const _ContactTile(
            icon: Icons.schedule_rounded,
            title: 'Support hours',
            value: supportHours,
          ),
        ],
      ),
    );
  }
}

class _Faq {
  const _Faq({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.grey,
              ),
          ],
        ),
      ),
    );
  }
}

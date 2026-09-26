import 'package:flutter/material.dart';

/// A small badge for a payment method (bKash, Nagad, card, COD).
///
/// Each one shows its own icon from assets/icons/payment/. Card uses a
/// generic "credit cards" icon (not a specific network's logo) - swap in
/// Visa/Mastercard/gateway artwork there once a real card provider is
/// connected.
class PaymentBadge extends StatelessWidget {
  const PaymentBadge({
    super.key,
    required this.method,
    this.size = 40,
  });

  /// 'bkash', 'nagad', 'card' or 'cod'.
  final String method;
  final double size;

  static const Map<String, String> _logos = {
    'bkash': 'assets/icons/payment/bkash_logo.png',
    'nagad': 'assets/icons/payment/nagad_logo.png',
    'card': 'assets/icons/payment/card_icon.png',
    'cod': 'assets/icons/payment/cod_icon.png',
  };

  @override
  Widget build(BuildContext context) {
    final logo = _logos[method];

    if (logo == null) {
      // Unknown method - a plain fallback icon so the app never crashes.
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF888888),
          borderRadius: BorderRadius.circular(size * 0.28),
        ),
        child: Icon(
          Icons.payments_rounded,
          color: Colors.white,
          size: size * 0.5,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Image.asset(logo, fit: BoxFit.contain),
    );
  }
}

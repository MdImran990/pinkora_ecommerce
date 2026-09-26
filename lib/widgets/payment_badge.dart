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
    this.withBackground = true,
  });

  /// 'bkash', 'nagad', 'card' or 'cod'.
  final String method;
  final double size;

  /// When true (default), the logo sits on a small white rounded card of
  /// its own - good for a plain list row. Set to false to show just the
  /// logo at full size, for places that already have their own background
  /// (like a bigger selectable payment tile).
  final bool withBackground;

  static const Map<String, String> _logos = {
    'bkash': 'assets/icons/payment/bkash_logo.png',
    'nagad': 'assets/icons/payment/nagad_logo.png',
    'card': 'assets/icons/payment/card_icon.png',
    'cod': 'assets/icons/payment/cod_icon.png',
  };

  // The 4 source images aren't the same shape (Nagad's is a wide
  // logo+wordmark, the others are closer to square). Matching everything
  // to the same fixed WIDTH and HEIGHT box makes the wide one look tiny
  // by comparison, so the background-free mode instead matches everything
  // to the same HEIGHT and lets the width follow each logo's own shape -
  // that's what actually makes all four look "the same size".
  static const Map<String, double> _aspectRatio = {
    'bkash': 499 / 475,
    'nagad': 500 / 238,
    'card': 130 / 126,
    'cod': 118 / 136,
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

    if (!withBackground) {
      return SizedBox(
        height: size,
        child: AspectRatio(
          aspectRatio: _aspectRatio[method] ?? 1.0,
          child: Image.asset(logo, fit: BoxFit.contain),
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

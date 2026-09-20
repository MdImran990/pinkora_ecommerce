import 'package:flutter/material.dart';

/// '#FF6B9D' -> Color, or null when the text is not a hex color.
Color? colorFromHex(String hex) {
  var value = hex.trim().replaceFirst('#', '');

  if (value.length == 6) value = 'FF$value';

  if (value.length != 8) return null;

  final parsed = int.tryParse(value, radix: 16);

  return parsed == null ? null : Color(parsed);
}

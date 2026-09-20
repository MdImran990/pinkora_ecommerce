class Validators {
  Validators._();

  static String? required(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$label required';
    }
    return null;
  }

  /// Bangladesh mobile number, e.g. 01712345678 or +8801712345678
  static String? phone(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Phone number required';

    final ok = RegExp(r'^(?:\+?88)?01[3-9]\d{8}$').hasMatch(text);

    return ok ? null : 'Enter a valid Bangladesh phone number';
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Email required';

    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);

    return ok ? null : 'Enter a valid email';
  }
}

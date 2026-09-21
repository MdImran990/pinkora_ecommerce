/// Everything you need to change when the backend is ready.
class ApiConstants {
  ApiConstants._();

  /// TODO: put your real API address here (no trailing slash).
  static const String baseUrl = 'https://api.example.com/v1';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // ── Endpoints (rename to match your backend) ──
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String profile = '/me';

  static const String categories = '/categories';
  static const String products = '/products';
  static const String productReviews = '/products/{id}/reviews';

  static const String orders = '/orders';
  static const String addresses = '/addresses';
  static const String notifications = '/notifications';
}

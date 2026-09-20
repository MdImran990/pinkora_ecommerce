import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../widgets/custom_snackbar.dart';

/// Holds only observable state and actions (no TextEditingController and
/// no GlobalKey). Each auth screen owns its own text controllers and form
/// key, so they are disposed together with that screen.
///
/// Registered as permanent (see AppBinding / AuthBinding).
class AuthController extends GetxController {
  final AuthRepository _repo = Get.find<AuthRepository>();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;

  /// Email saved by "Remember me" (used to prefill the login form).
  String? get rememberedEmail => _repo.rememberedEmail;

  void togglePassword() => isPasswordHidden.toggle();

  void toggleRemember(bool? val) {
    rememberMe.value = val ?? false;
  }

  String _messageOf(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  // ── LOGIN ── (the screen validates its form first)
  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      // Small delay to mimic a network call.
      await Future.delayed(const Duration(milliseconds: 900));

      await _repo.login(identifier: email, password: password);

      await _repo.setRememberedEmail(
        rememberMe.value ? email.trim() : null,
      );

      isLoading.value = false;

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      isLoading.value = false;

      CustomSnackbar.error('Login Failed', _messageOf(e));
    }
  }

  // ── REGISTER ── (the screen validates its form first)
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 900));

      await _repo.register(
        name: name,
        identifier: email,
        password: password,
      );

      isLoading.value = false;

      Get.offAllNamed(AppRoutes.login);

      await Future.delayed(const Duration(milliseconds: 500));

      CustomSnackbar.success(
        'Account Created! 🎉',
        'Please login with your credentials',
      );
    } catch (e) {
      isLoading.value = false;

      CustomSnackbar.error('Registration Failed', _messageOf(e));
    }
  }

  // ── FORGOT PASSWORD ──
  Future<void> forgotPassword(String email) async {
    if (isLoading.value) return;

    final value = email.trim();

    if (value.isEmpty) {
      CustomSnackbar.error(
        'Email Required',
        'Please enter your email or phone number',
      );
      return;
    }

    isLoading.value = true;

    // Temporary local delay.
    // API / OTP / email reset will be connected later.
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    CustomSnackbar.success(
      'Reset Link Sent! 📩',
      'Please check your email or phone',
    );
  }

  // ── SOCIAL LOGIN (needs OAuth setup + backend) ──
  void socialLogin(String provider) {
    CustomSnackbar.info(
      'Coming Soon',
      '$provider login will be available after backend setup',
    );
  }

  // ── LOGOUT ──
  Future<void> logout() async {
    await _repo.logout();

    Get.offAllNamed(AppRoutes.login);
  }

  // ── NAVIGATION ──
  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }
}

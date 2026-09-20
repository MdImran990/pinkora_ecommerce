import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../core/constants/storage_keys.dart';
import '../model/user_model.dart';

/// Login session and profile.
///
/// This is a local mock: accounts live on the device. When the backend is
/// ready, replace the bodies of login/register/logout with API calls.
class AuthRepository {
  final GetStorage _box = GetStorage();

  bool get isLoggedIn => _box.read<bool>(StorageKeys.isLoggedIn) ?? false;

  UserModel? get currentUser {
    final raw = _box.read<String>(StorageKeys.currentUser);

    if (raw == null || raw.isEmpty) return null;

    try {
      return UserModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  String? get rememberedEmail => _box.read<String>(StorageKeys.rememberedEmail);

  Future<void> setRememberedEmail(String? value) async {
    if (value == null || value.isEmpty) {
      await _box.remove(StorageKeys.rememberedEmail);
    } else {
      await _box.write(StorageKeys.rememberedEmail, value);
    }
  }

  Map<String, dynamic> _readAccounts() {
    final raw = _box.read<String>(StorageKeys.accounts);

    if (raw == null || raw.isEmpty) return {};

    try {
      return Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeAccounts(Map<String, dynamic> accounts) {
    return _box.write(StorageKeys.accounts, jsonEncode(accounts));
  }

  static String _normalize(String identifier) =>
      identifier.trim().toLowerCase();

  static UserModel _userFromIdentifier(String identifier, {String? name}) {
    final id = identifier.trim();
    final isEmail = id.contains('@');

    final fallbackName = isEmail
        ? id.split('@').first
        : (id.isEmpty ? 'Pinkora User' : id);

    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: (name == null || name.trim().isEmpty)
          ? fallbackName
          : name.trim(),
      email: isEmail ? id : '',
      phone: isEmail ? '' : id,
    );
  }

  /// Registered account -> password is checked.
  /// Unknown account -> accepted (mock mode), so the app can be tried without
  /// registering first.
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    final accounts = _readAccounts();
    final key = _normalize(identifier);
    final account = accounts[key];

    UserModel user;

    if (account is Map) {
      final data = Map<String, dynamic>.from(account);

      if (data['password'] != password) {
        throw Exception('Wrong password. Please try again.');
      }

      user = UserModel.fromJson(
        Map<String, dynamic>.from(data['user'] as Map),
      );
    } else {
      user = _userFromIdentifier(identifier);
    }

    await _box.write(StorageKeys.currentUser, jsonEncode(user.toJson()));
    await _box.write(StorageKeys.isLoggedIn, true);

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String identifier,
    required String password,
  }) async {
    final accounts = _readAccounts();
    final key = _normalize(identifier);

    if (accounts.containsKey(key)) {
      throw Exception('An account with this email/phone already exists.');
    }

    final user = _userFromIdentifier(identifier, name: name);

    accounts[key] = {
      'password': password,
      'user': user.toJson(),
    };

    await _writeAccounts(accounts);

    return user;
  }

  Future<void> updateProfile(UserModel user) async {
    await _box.write(StorageKeys.currentUser, jsonEncode(user.toJson()));

    // Keep the saved account in sync (if this user registered here).
    final accounts = _readAccounts();
    var changed = false;

    for (final entry in accounts.entries.toList()) {
      final data = entry.value;

      if (data is Map && data['user'] is Map) {
        final saved = Map<String, dynamic>.from(data['user'] as Map);

        if (saved['id'] == user.id) {
          accounts[entry.key] = {
            'password': data['password'],
            'user': user.toJson(),
          };
          changed = true;
        }
      }
    }

    if (changed) {
      await _writeAccounts(accounts);
    }
  }

  Future<void> logout() async {
    await _box.write(StorageKeys.isLoggedIn, false);
  }
}

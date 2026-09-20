import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../core/constants/storage_keys.dart';
import '../mock/mock_data.dart';
import '../model/notification_model.dart';

class NotificationRepository {
  final GetStorage _box = GetStorage();

  List<NotificationModel> load() {
    final raw = _box.read<String>(StorageKeys.notifications);

    // First run: show a few welcome notifications.
    if (raw == null) return MockData.welcomeNotifications();

    if (raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List;

      return list
          .map(
            (e) => NotificationModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<NotificationModel> items) {
    return _box.write(
      StorageKeys.notifications,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }
}

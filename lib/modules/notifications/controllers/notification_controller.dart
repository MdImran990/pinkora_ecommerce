import 'package:get/get.dart';

import '../../../data/model/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';

/// Permanent controller so the home bell badge can show the unread count.
class NotificationController extends GetxController {
  final NotificationRepository _repo = Get.find<NotificationRepository>();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    notifications.assignAll(_repo.load());
  }

  int get unreadCount {
    return notifications.where((n) => !n.isRead).length;
  }

  Future<void> add({
    required String title,
    required String body,
    String type = 'system',
  }) async {
    notifications.insert(
      0,
      NotificationModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        body: body,
        createdAt: DateTime.now(),
        type: type,
      ),
    );

    await _repo.save(notifications.toList());
  }

  Future<void> markRead(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);

    if (index == -1 || notifications[index].isRead) return;

    notifications[index] = notifications[index].copyWith(isRead: true);

    await _repo.save(notifications.toList());
  }

  Future<void> markAllRead() async {
    notifications.assignAll(
      notifications.map((n) => n.copyWith(isRead: true)).toList(),
    );

    await _repo.save(notifications.toList());
  }

  Future<void> remove(String id) async {
    notifications.removeWhere((n) => n.id == id);

    await _repo.save(notifications.toList());
  }

  Future<void> clearAll() async {
    notifications.clear();

    await _repo.save(const []);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/model/notification_model.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/pinkora_app_bar.dart';
import '../controllers/notification_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: pinkoraAppBar(
        'Notifications',
        actions: [
          Obx(
                () {
              if (controller.unreadCount == 0) {
                return const SizedBox.shrink();
              }

              return TextButton(
                onPressed: controller.markAllRead,
                child: const Text(
                  'Read all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(
            () {
          final list = controller.notifications;

          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'No notifications',
              message: 'You are all caught up. New updates will appear here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];

              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) => controller.remove(item.id),
                child: _NotificationTile(
                  item: item,
                  onTap: () => controller.markRead(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.onTap,
  });

  final NotificationModel item;
  final VoidCallback onTap;

  IconData _icon() {
    switch (item.type) {
      case 'order':
        return Icons.local_shipping_rounded;
      case 'promo':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.white : const Color(0xFFFFF7FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isRead ? AppColors.border : AppColors.primaryLight,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon(), color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: item.isRead
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGrey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeAgo(item.createdAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

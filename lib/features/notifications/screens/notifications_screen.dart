import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/empty_state.dart';
import '../models/notification_model.dart';
import '../services/notification_controller.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _open(BuildContext context, AppNotification notification) {
    NotificationController.instance.markAsRead(notification.id);
    final route = notification.route;
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  void _confirmClearAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: const Text('Clear all notifications?'),
        content: const Text('This removes every notification from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              NotificationController.instance.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = controller.notifications;
        final unread = controller.unreadCount;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              if (unread > 0)
                TextButton(
                  onPressed: controller.markAllAsRead,
                  child: const Text('Mark all read'),
                ),
              if (items.isNotEmpty)
                IconButton(
                  tooltip: 'Clear all',
                  onPressed: () => _confirmClearAll(context),
                  icon: const Icon(Icons.delete_sweep_outlined),
                ),
              const SizedBox(width: AppSpacing.spaceXs),
            ],
          ),
          body: items.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: 'No notifications',
                    message: 'Payment, membership and booking updates '
                        'will show up here.',
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.spaceSm,
                    AppSpacing.gutter,
                    AppSpacing.space2xl,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.spaceSm),
                  itemBuilder: (context, index) {
                    final notification = items[index];
                    return Dismissible(
                      key: ValueKey(notification.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => controller.remove(notification.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(
                          right: AppSpacing.spaceLg,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorContainer,
                          borderRadius: AppRadius.large,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                      child: NotificationTile(
                        notification: notification,
                        onTap: () => _open(context, notification),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

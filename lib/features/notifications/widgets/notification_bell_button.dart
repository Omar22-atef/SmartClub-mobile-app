import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../services/notification_controller.dart';

/// App bar bell icon with an unread badge. Opens the Notifications screen.
///
/// Usage: `AppBar(actions: const [NotificationBellButton()])`
class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final count = controller.unreadCount;
        return IconButton(
          tooltip: 'Notifications',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          icon: Badge(
            isLabelVisible: count > 0,
            backgroundColor: AppColors.limeNeon,
            textColor: AppColors.midnightBlack,
            label: Text(count > 9 ? '9+' : '$count'),
            child: Icon(
              count > 0
                  ? Icons.notifications
                  : Icons.notifications_outlined,
              color: AppColors.midnightBlack,
            ),
          ),
        );
      },
    );
  }
}

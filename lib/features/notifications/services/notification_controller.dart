import 'package:flutter/foundation.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../subscriptions/models/subscription_model.dart';
import '../../subscriptions/services/membership_controller.dart';
import '../models/notification_model.dart';

/// In-app notifications (newest first).
///
/// Other features call [push] when something happens (payment done,
/// membership renewed, booking confirmed...). In the backend phase this can be
/// fed by the API / Firebase Cloud Messaging instead.
class NotificationController extends ChangeNotifier {
  NotificationController._() {
    _seedMockData();
  }

  static final NotificationController instance = NotificationController._();

  final List<AppNotification> _items = [];
  int _nextId = 1;

  List<AppNotification> get notifications => List.unmodifiable(_items);

  int get unreadCount => _items.where((n) => !n.isRead).length;

  AppNotification push({
    required String title,
    required String body,
    required NotificationType type,
    String? route,
  }) {
    final notification = AppNotification(
      id: '${_nextId++}',
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
      route: route,
    );
    _items.insert(0, notification);
    notifyListeners();
    return notification;
  }

  void markAsRead(String id) {
    final index = _items.indexWhere((n) => n.id == id);
    if (index == -1 || _items[index].isRead) return;
    _items[index] = _items[index].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllAsRead() {
    if (unreadCount == 0) return;
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }

  void _seedMockData() {
    final now = DateTime.now();

    _items.add(
      AppNotification(
        id: '${_nextId++}',
        title: 'Welcome to Smart Club',
        body: 'Book facilities, join events and manage your membership '
            'from one place.',
        type: NotificationType.general,
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
    );

    final membership = MembershipController.instance.membership;
    if (membership != null &&
        membership.status == MembershipStatus.expiringSoon) {
      final days = membership.daysRemaining;
      _items.insert(
        0,
        AppNotification(
          id: '${_nextId++}',
          title: 'Membership expiring soon',
          body: 'Your ${membership.plan.name} membership expires in $days '
              '${days == 1 ? 'day' : 'days'} '
              '(${AppFormatters.date(membership.expiryDate)}). '
              'Renew now to keep your access.',
          type: NotificationType.membership,
          createdAt: now.subtract(const Duration(hours: 2)),
          route: AppRoutes.renewal,
        ),
      );
    }
  }
}

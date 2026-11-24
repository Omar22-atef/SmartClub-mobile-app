import 'package:flutter/material.dart';

enum NotificationType {
  payment(Icons.receipt_long_outlined),
  membership(Icons.card_membership_outlined),
  booking(Icons.event_available_outlined),
  event(Icons.celebration_outlined),
  general(Icons.notifications_outlined);

  const NotificationType(this.icon);
  final IconData icon;
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.route,
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  /// Optional named route (without arguments) opened when the user taps it.
  final String? route;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      route: route,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type.name,
        'created_at': createdAt.toIso8601String(),
        'is_read': isRead,
        'route': route,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.byName(json['type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool? ?? false,
      route: json['route'] as String?,
    );
  }
}

import 'package:flutter/material.dart';

class GuestPrivilegeOption {
  const GuestPrivilegeOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;

  GuestPrivilegeOption copyWith({bool? isEnabled}) {
    return GuestPrivilegeOption(
      id: id,
      title: title,
      subtitle: subtitle,
      icon: icon,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

enum GuestPassStatus { completed, pending }

class GuestPassRecord {
  const GuestPassRecord({
    required this.id,
    required this.initials,
    required this.guestName,
    required this.email,
    required this.phoneNumber,
    required this.visitDate,
    required this.subtitle,
    required this.status,
    required this.passCode,
    this.clearedZones = const [
      'Clubhouse & Locker Access',
      'Tennis / Padel Court Access',
    ],
    this.sponsorName = 'Alex Vance',
    this.sponsorId = '#SC-88294',
  });

  final String id;
  final String initials;
  final String guestName;
  final String email;
  final String phoneNumber;
  final String visitDate;
  final String subtitle;
  final GuestPassStatus status;
  final String passCode;
  final List<String> clearedZones;
  final String sponsorName;
  final String sponsorId;

  static String extractInitials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'GP';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
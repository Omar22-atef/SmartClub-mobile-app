import 'package:flutter/material.dart';

enum EventCategory {
  all('All'),
  sports('Sports'),
  social('Social'),
  tournaments('Tournaments'),
  workshops('Workshops');

  final String label;
  const EventCategory(this.label);
  String get categoryLabel => label;
}

class ClubEvent {
  final String id;
  final String title;
  final EventCategory category;
  final DateTime date;
  final String time;
  final String location;
  final String description;
  final String fullDescription;
  final String organizer;
  final int maxCapacity;
  int registeredCount;
  final DateTime? registrationDeadline;
  final IconData icon;

  ClubEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.fullDescription,
    required this.organizer,
    required this.maxCapacity,
    required this.registeredCount,
    this.registrationDeadline,
    required this.icon,
  });

  int get remainingSeats => maxCapacity - registeredCount;
  bool get isFull => remainingSeats <= 0;
  bool get hasPassed => date.isBefore(DateTime.now());

  String get categoryLabel => category.label;
}

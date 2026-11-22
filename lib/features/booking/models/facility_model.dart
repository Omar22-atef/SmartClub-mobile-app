import 'package:flutter/material.dart';

enum FacilityCategory {
  all('All'),
  sports('Sports'),
  swimming('Swimming'),
  fitness('Fitness'),
  recreation('Recreation');

  final String label;
  const FacilityCategory(this.label);
  String get categoryLabel => label;
}

class Facility {
  final String id;
  final String name;
  final FacilityCategory category;
  final String description;
  final String longDescription;
  final double pricePerHour;
  final bool isAvailable;
  final double rating;
  final String location;
  final String operatingHours;
  final int capacity;
  final List<String> equipment;
  final List<String> rules;
  final List<String> amenities;
  final String bookingDuration;
  final IconData icon;

  const Facility({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.longDescription,
    required this.pricePerHour,
    required this.isAvailable,
    required this.rating,
    required this.location,
    required this.operatingHours,
    required this.capacity,
    required this.equipment,
    required this.rules,
    required this.amenities,
    required this.bookingDuration,
    required this.icon,
  });

  String get categoryLabel => category.label;
}

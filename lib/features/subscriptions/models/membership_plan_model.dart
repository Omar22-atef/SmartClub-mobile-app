import 'package:flutter/material.dart';

/// A membership plan the club sells (Monthly, Quarterly, ...).
class MembershipPlan {
  const MembershipPlan({
    required this.id,
    required this.name,
    required this.tagline,
    required this.durationMonths,
    required this.price,
    required this.features,
    required this.guestPassesPerMonth,
    this.isPopular = false,
    this.icon = Icons.card_membership_outlined,
  });

  final String id;
  final String name;
  final String tagline;
  final int durationMonths;
  final double price;
  final List<String> features;
  final int guestPassesPerMonth;
  final bool isPopular;
  final IconData icon;

  double get monthlyPrice => price / durationMonths;

  String get durationLabel {
    if (durationMonths == 1) return '1 Month';
    if (durationMonths == 12) return '1 Year';
    return '$durationMonths Months';
  }

  /// How much this plan saves vs. paying [base] (usually Monthly) for the
  /// same number of months. Returns 0 if there is no saving.
  double savingsComparedTo(MembershipPlan base) {
    final saving = base.monthlyPrice * durationMonths - price;
    return saving > 0 ? saving : 0;
  }

  // ---------------------------------------------------------------------------
  // JSON (ready for the backend phase)
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'duration_months': durationMonths,
        'price': price,
        'features': features,
        'guest_passes_per_month': guestPassesPerMonth,
        'is_popular': isPopular,
      };

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id'].toString(),
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      durationMonths: json['duration_months'] as int,
      price: (json['price'] as num).toDouble(),
      features: List<String>.from(json['features'] as List? ?? const []),
      guestPassesPerMonth: json['guest_passes_per_month'] as int? ?? 0,
      isPopular: json['is_popular'] as bool? ?? false,
    );
  }
}

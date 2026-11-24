import 'package:flutter/material.dart';

import '../models/membership_plan_model.dart';

/// Mock membership plans. Will be replaced by `GET /membership-plans`
/// in the backend phase.
const List<MembershipPlan> mockMembershipPlans = [
  MembershipPlan(
    id: 'monthly',
    name: 'Monthly',
    tagline: 'Flexible access, renew month by month',
    durationMonths: 1,
    price: 49,
    guestPassesPerMonth: 1,
    icon: Icons.bolt_outlined,
    features: [
      'Gym & fitness floor access',
      'Swimming pool access',
      '1 guest pass per month',
      'Book club facilities',
    ],
  ),
  MembershipPlan(
    id: 'quarterly',
    name: 'Quarterly',
    tagline: 'Our most popular plan',
    durationMonths: 3,
    price: 129,
    guestPassesPerMonth: 2,
    isPopular: true,
    icon: Icons.local_fire_department_outlined,
    features: [
      'Everything in Monthly',
      '2 guest passes per month',
      'Access to all club events',
      'Locker room access',
    ],
  ),
  MembershipPlan(
    id: 'semi_annual',
    name: 'Semi-Annual',
    tagline: 'Six months of full club access',
    durationMonths: 6,
    price: 239,
    guestPassesPerMonth: 3,
    icon: Icons.workspace_premium_outlined,
    features: [
      'Everything in Quarterly',
      '3 guest passes per month',
      'Tennis & padel court access',
      'Thermal spa access',
    ],
  ),
  MembershipPlan(
    id: 'annual',
    name: 'Annual',
    tagline: 'Best value for committed members',
    durationMonths: 12,
    price: 449,
    guestPassesPerMonth: 4,
    icon: Icons.diamond_outlined,
    features: [
      'Everything in Semi-Annual',
      '4 guest passes per month',
      'Free personal training session',
      'Priority event registration',
    ],
  ),
];

MembershipPlan planById(String id) {
  return mockMembershipPlans.firstWhere(
    (plan) => plan.id == id,
    orElse: () => mockMembershipPlans.first,
  );
}

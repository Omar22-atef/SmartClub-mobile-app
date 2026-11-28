import 'package:flutter/material.dart';

/// Temporary UI-only data. Replace with SQLite services later.
class AdminMockData {
  AdminMockData._();

  static const stats = {
    'totalMembers': '1,248',
    'activeMembers': '1,180',
    'expiredMemberships': '68',
    'totalBookings': '3,412',
    'totalPayments': '\$48,290',
  };

  static const List<String> revenueMonths = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
  static const List<double> revenueValues = [6200, 7400, 6900, 8800, 9600, 9390];

  static const List<String> bookingDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const List<double> bookingValues = [42, 55, 48, 61, 70, 88, 64];

  static const Map<String, double> planDistribution = {
    'Bronze': 210,
    'Silver': 380,
    'Gold': 450,
    'Platinum': 208,
  };

  static final List<Map<String, dynamic>> activity = [
    {'title': 'Sophia Martinez — Guest QR Scanned', 'sub': 'Gate B • 2m ago', 'tag': 'ENTRY', 'icon': Icons.qr_code_2},
    {'title': 'Court 02 Booked — Marcus Reed', 'sub': '\$35 • 14m ago', 'tag': 'BOOKING', 'icon': Icons.sports_tennis},
    {'title': 'Membership Renewed — Elena Rostova', 'sub': '\$249 • 1h ago', 'tag': 'PAID', 'icon': Icons.verified},
  ];

  static final List<Map<String, dynamic>> members = [
    {'id': 'M-1001', 'name': 'Sophia Martinez', 'email': 'sophia.m@mail.com', 'plan': 'Gold', 'status': 'Active', 'expiry': '2027-03-14'},
    {'id': 'M-1002', 'name': 'Marcus Reed', 'email': 'marcus.r@mail.com', 'plan': 'Silver', 'status': 'Active', 'expiry': '2027-01-02'},
    {'id': 'M-1003', 'name': 'Elena Rostova', 'email': 'elena.r@mail.com', 'plan': 'Platinum', 'status': 'Active', 'expiry': '2027-11-20'},
    {'id': 'M-1004', 'name': 'Omar Hassan', 'email': 'omar.h@mail.com', 'plan': 'Silver', 'status': 'Expired', 'expiry': '2026-09-30'},
    {'id': 'M-1005', 'name': 'Layla Ibrahim', 'email': 'layla.i@mail.com', 'plan': 'Gold', 'status': 'Suspended', 'expiry': '2027-02-11'},
    {'id': 'M-1006', 'name': 'Daniel Kim', 'email': 'daniel.k@mail.com', 'plan': 'Bronze', 'status': 'Expired', 'expiry': '2026-10-15'},
    {'id': 'M-1007', 'name': 'Nour Adel', 'email': 'nour.a@mail.com', 'plan': 'Platinum', 'status': 'Active', 'expiry': '2027-06-01'},
  ];

  static final List<Map<String, dynamic>> guests = [
    {'name': 'Karim Salem', 'invitedBy': 'Marcus Reed', 'date': '2026-11-25', 'status': 'Pending'},
    {'name': 'Mona Fathy', 'invitedBy': 'Sophia Martinez', 'date': '2026-11-24', 'status': 'Checked In'},
    {'name': 'Youssef Ali', 'invitedBy': 'Elena Rostova', 'date': '2026-11-20', 'status': 'Expired'},
    {'name': 'Hana Gamal', 'invitedBy': 'Nour Adel', 'date': '2026-11-26', 'status': 'Pending'},
    {'name': 'Tarek Nabil', 'invitedBy': 'Omar Hassan', 'date': '2026-11-22', 'status': 'Cancelled'},
  ];

  static final List<Map<String, dynamic>> bookings = [
    {'id': 'B-5001', 'facility': 'Tennis Court 02', 'member': 'Marcus Reed', 'date': '2026-11-24', 'slot': '18:00 - 19:00', 'price': 35, 'status': 'Upcoming'},
    {'id': 'B-5002', 'facility': 'Swimming Pool', 'member': 'Sophia Martinez', 'date': '2026-11-24', 'slot': '07:00 - 08:00', 'price': 20, 'status': 'Completed'},
    {'id': 'B-5003', 'facility': 'Padel Court 01', 'member': 'Nour Adel', 'date': '2026-11-25', 'slot': '20:00 - 21:00', 'price': 40, 'status': 'Upcoming'},
    {'id': 'B-5004', 'facility': 'Gym Studio', 'member': 'Elena Rostova', 'date': '2026-11-23', 'slot': '09:00 - 10:00', 'price': 15, 'status': 'Cancelled'},
    {'id': 'B-5005', 'facility': 'Tennis Court 01', 'member': 'Daniel Kim', 'date': '2026-11-22', 'slot': '16:00 - 17:00', 'price': 35, 'status': 'Completed'},
  ];

  static final List<Map<String, dynamic>> plans = [
    {'name': 'Bronze', 'price': 99, 'duration': '1 month', 'perks': 'Gym access, 2 guest passes', 'active': true},
    {'name': 'Silver', 'price': 149, 'duration': '3 months', 'perks': 'Gym + pool, 4 guest passes', 'active': true},
    {'name': 'Gold', 'price': 249, 'duration': '6 months', 'perks': 'All facilities, 8 guest passes', 'active': true},
    {'name': 'Platinum', 'price': 449, 'duration': '12 months', 'perks': 'Unlimited access, priority booking', 'active': false},
  ];

  static final List<Map<String, dynamic>> payments = [
    {'id': 'P-9001', 'member': 'Elena Rostova', 'type': 'Membership renewal', 'amount': 249, 'date': '2026-11-24', 'status': 'Paid'},
    {'id': 'P-9002', 'member': 'Marcus Reed', 'type': 'Court booking', 'amount': 35, 'date': '2026-11-24', 'status': 'Paid'},
    {'id': 'P-9003', 'member': 'Omar Hassan', 'type': 'Membership renewal', 'amount': 149, 'date': '2026-11-23', 'status': 'Pending'},
    {'id': 'P-9004', 'member': 'Elena Rostova', 'type': 'Gym booking', 'amount': 15, 'date': '2026-11-23', 'status': 'Refunded'},
    {'id': 'P-9005', 'member': 'Nour Adel', 'type': 'Event ticket', 'amount': 60, 'date': '2026-11-22', 'status': 'Paid'},
  ];

  static final List<Map<String, dynamic>> events = [
    {'title': 'Club Tennis Open', 'location': 'Center Court', 'date': '2026-12-05', 'capacity': 64, 'registered': 48, 'description': 'Annual members tournament.'},
    {'title': 'Summer Pool Party', 'location': 'Swimming Pool', 'date': '2026-12-12', 'capacity': 120, 'registered': 97, 'description': 'Music, food and games.'},
    {'title': 'Yoga Morning', 'location': 'Gym Studio', 'date': '2026-12-18', 'capacity': 25, 'registered': 25, 'description': 'Relaxing weekend session.'},
  ];

  static final List<Map<String, dynamic>> facilities = [
    {'name': 'Tennis Court 01', 'type': 'Court', 'price': 35, 'capacity': 4, 'available': true},
    {'name': 'Tennis Court 02', 'type': 'Court', 'price': 35, 'capacity': 4, 'available': true},
    {'name': 'Padel Court 01', 'type': 'Court', 'price': 40, 'capacity': 4, 'available': false},
    {'name': 'Swimming Pool', 'type': 'Pool', 'price': 20, 'capacity': 30, 'available': true},
    {'name': 'Gym Studio', 'type': 'Gym', 'price': 15, 'capacity': 20, 'available': true},
  ];
}
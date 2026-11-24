import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project_mobile_application/core/utils/app_date_utils.dart';
import 'package:final_project_mobile_application/features/subscriptions/services/membership_controller.dart';
import 'package:final_project_mobile_application/features/subscriptions/services/membership_plans_data.dart';
import 'package:final_project_mobile_application/main.dart';

void main() {
  group('AppDateUtils.addMonths', () {
    test('adds months normally', () {
      expect(
        AppDateUtils.addMonths(DateTime(2026, 3, 15), 3),
        DateTime(2026, 6, 15),
      );
    });

    test('clamps to the last day of shorter months', () {
      expect(
        AppDateUtils.addMonths(DateTime(2026, 1, 31), 1),
        DateTime(2026, 2, 28),
      );
    });

    test('rolls over the year', () {
      expect(
        AppDateUtils.addMonths(DateTime(2026, 11, 24), 12),
        DateTime(2027, 11, 24),
      );
    });
  });

  test('renewing an active membership continues from the current expiry', () {
    final controller = MembershipController.instance;
    final currentExpiry = controller.membership!.expiryDate;
    final plan = planById('quarterly');

    expect(
      controller.calculateNewExpiry(plan),
      AppDateUtils.addMonths(currentExpiry, 3),
    );
  });

  testWidgets('App opens with the bottom navigation tabs', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Membership'), findsWidgets);
  });
}

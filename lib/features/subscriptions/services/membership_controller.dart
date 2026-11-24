import 'package:flutter/foundation.dart';

import '../../../core/utils/app_date_utils.dart';
import '../models/membership_plan_model.dart';
import '../models/subscription_model.dart';
import 'membership_plans_data.dart';

/// Holds the member's membership + subscription history.
///
/// Screens listen to it (ListenableBuilder) so the membership status updates
/// everywhere right after a successful payment.
class MembershipController extends ChangeNotifier {
  MembershipController._() {
    _seedMockData();
  }

  static final MembershipController instance = MembershipController._();

  Membership? _membership;
  final List<SubscriptionRecord> _history = [];
  int _nextRecordId = 1004;

  Membership? get membership => _membership;

  MembershipStatus get status => _membership?.status ?? MembershipStatus.none;

  List<MembershipPlan> get plans => mockMembershipPlans;

  /// Newest first.
  List<SubscriptionRecord> get history => List.unmodifiable(_history);

  // ---------------------------------------------------------------------------
  // Expiry calculation
  // ---------------------------------------------------------------------------

  /// When a newly paid period would start:
  /// - still active  -> continues from the current expiry date (no lost days)
  /// - expired / none -> starts today
  DateTime get nextPeriodStart {
    final today = AppDateUtils.today();
    final current = _membership;
    if (current != null && !current.expiryDate.isBefore(today)) {
      return AppDateUtils.dateOnly(current.expiryDate);
    }
    return today;
  }

  /// The expiry date the member would get after paying for [plan].
  DateTime calculateNewExpiry(MembershipPlan plan) {
    return AppDateUtils.addMonths(nextPeriodStart, plan.durationMonths);
  }

  /// Extra days [plan] would add on top of the current expiry.
  int daysAddedBy(MembershipPlan plan) {
    final currentExpiry = _membership?.expiryDate;
    final from = currentExpiry != null &&
            !currentExpiry.isBefore(AppDateUtils.today())
        ? currentExpiry
        : AppDateUtils.today();
    return AppDateUtils.daysBetween(from, calculateNewExpiry(plan));
  }

  SubscriptionAction actionFor(MembershipPlan plan) {
    final current = _membership;
    if (current == null) return SubscriptionAction.newSubscription;
    if (current.plan.id == plan.id) return SubscriptionAction.renewal;
    return SubscriptionAction.planChange;
  }

  // ---------------------------------------------------------------------------
  // Called by PaymentController after a successful payment
  // ---------------------------------------------------------------------------

  SubscriptionRecord activate({
    required MembershipPlan plan,
    required String paymentId,
  }) {
    final start = nextPeriodStart;
    final end = AppDateUtils.addMonths(start, plan.durationMonths);
    final action = actionFor(plan);

    final record = SubscriptionRecord(
      id: '${_nextRecordId++}',
      planId: plan.id,
      planName: plan.name,
      action: action,
      periodStart: start,
      periodEnd: end,
      amount: plan.price,
      paymentId: paymentId,
      createdAt: DateTime.now(),
    );
    _history.insert(0, record);

    final current = _membership;
    if (current == null || current.status == MembershipStatus.expired) {
      _membership = Membership(
        memberId: current?.memberId ?? '20481',
        memberName: current?.memberName ?? 'Club Member',
        plan: plan,
        memberSince: current?.memberSince ?? AppDateUtils.today(),
        currentPeriodStart: start,
        expiryDate: end,
      );
    } else {
      // Still active: keep the current period start, push the expiry forward.
      _membership = current.copyWith(plan: plan, expiryDate: end);
    }

    notifyListeners();
    return record;
  }

  // ---------------------------------------------------------------------------
  // Mock data
  // ---------------------------------------------------------------------------

  void _seedMockData() {
    final today = AppDateUtils.today();
    final monthly = planById('monthly');
    final quarterly = planById('quarterly');

    // Current Quarterly period expires in 6 days -> "Expiring Soon",
    // so the renewal flow can be demoed right away.
    final currentEnd = today.add(const Duration(days: 6));
    final currentStart = AppDateUtils.addMonths(currentEnd, -3);
    final secondStart = AppDateUtils.addMonths(currentStart, -1);
    final firstStart = AppDateUtils.addMonths(secondStart, -1);

    _history.addAll([
      SubscriptionRecord(
        id: '1003',
        planId: quarterly.id,
        planName: quarterly.name,
        action: SubscriptionAction.planChange,
        periodStart: currentStart,
        periodEnd: currentEnd,
        amount: quarterly.price,
        paymentId: 'PAY-1003',
        createdAt: currentStart
            .subtract(const Duration(days: 1))
            .add(const Duration(hours: 18, minutes: 20)),
      ),
      SubscriptionRecord(
        id: '1002',
        planId: monthly.id,
        planName: monthly.name,
        action: SubscriptionAction.renewal,
        periodStart: secondStart,
        periodEnd: currentStart,
        amount: monthly.price,
        paymentId: 'PAY-1002',
        createdAt: secondStart
            .subtract(const Duration(days: 2))
            .add(const Duration(hours: 11, minutes: 5)),
      ),
      SubscriptionRecord(
        id: '1001',
        planId: monthly.id,
        planName: monthly.name,
        action: SubscriptionAction.newSubscription,
        periodStart: firstStart,
        periodEnd: secondStart,
        amount: monthly.price,
        paymentId: 'PAY-1001',
        createdAt: firstStart.add(const Duration(hours: 9, minutes: 40)),
      ),
    ]);

    _membership = Membership(
      memberId: '20481',
      memberName: 'Club Member',
      plan: quarterly,
      memberSince: firstStart,
      currentPeriodStart: currentStart,
      expiryDate: currentEnd,
    );
  }
}

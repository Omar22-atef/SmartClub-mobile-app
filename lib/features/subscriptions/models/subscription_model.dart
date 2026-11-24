import '../../../core/utils/app_date_utils.dart';
import 'membership_plan_model.dart';

/// Overall state of the member's membership.
enum MembershipStatus {
  active('Active'),
  expiringSoon('Expiring Soon'),
  expired('Expired'),
  none('No Membership');

  const MembershipStatus(this.label);
  final String label;
}

/// Why a subscription period was created.
enum SubscriptionAction {
  newSubscription('New Subscription'),
  renewal('Renewal'),
  planChange('Plan Change');

  const SubscriptionAction(this.label);
  final String label;
}

/// Where a subscription period sits relative to today.
enum SubscriptionPeriodStatus {
  active('Active'),
  scheduled('Scheduled'),
  completed('Completed');

  const SubscriptionPeriodStatus(this.label);
  final String label;
}

/// The member's current membership.
class Membership {
  const Membership({
    required this.memberId,
    required this.memberName,
    required this.plan,
    required this.memberSince,
    required this.currentPeriodStart,
    required this.expiryDate,
  });

  /// A membership is "expiring soon" when this many days or fewer remain.
  static const int expiringSoonThresholdDays = 7;

  final String memberId;
  final String memberName;
  final MembershipPlan plan;
  final DateTime memberSince;
  final DateTime currentPeriodStart;

  /// Last day the membership is valid (inclusive).
  final DateTime expiryDate;

  int get daysRemaining =>
      AppDateUtils.daysBetween(AppDateUtils.today(), expiryDate);

  MembershipStatus get status {
    if (daysRemaining < 0) return MembershipStatus.expired;
    if (daysRemaining <= expiringSoonThresholdDays) {
      return MembershipStatus.expiringSoon;
    }
    return MembershipStatus.active;
  }

  bool get isActive => status != MembershipStatus.expired;

  /// 0.0 at the start of the period, 1.0 at expiry.
  double get periodProgress {
    final total = AppDateUtils.daysBetween(currentPeriodStart, expiryDate);
    if (total <= 0) return 1;
    final elapsed =
        AppDateUtils.daysBetween(currentPeriodStart, AppDateUtils.today());
    return (elapsed / total).clamp(0.0, 1.0).toDouble();
  }

  String get memberCardNumber => 'SC-$memberId';

  Membership copyWith({
    MembershipPlan? plan,
    DateTime? currentPeriodStart,
    DateTime? expiryDate,
  }) {
    return Membership(
      memberId: memberId,
      memberName: memberName,
      plan: plan ?? this.plan,
      memberSince: memberSince,
      currentPeriodStart: currentPeriodStart ?? this.currentPeriodStart,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'member_id': memberId,
        'member_name': memberName,
        'plan_id': plan.id,
        'member_since': memberSince.toIso8601String(),
        'current_period_start': currentPeriodStart.toIso8601String(),
        'expiry_date': expiryDate.toIso8601String(),
      };
}

/// One paid subscription period (used for the membership history).
class SubscriptionRecord {
  const SubscriptionRecord({
    required this.id,
    required this.planId,
    required this.planName,
    required this.action,
    required this.periodStart,
    required this.periodEnd,
    required this.amount,
    required this.paymentId,
    required this.createdAt,
  });

  final String id;
  final String planId;
  final String planName;
  final SubscriptionAction action;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double amount;
  final String paymentId;
  final DateTime createdAt;

  String get referenceId => 'SUB-${id.padLeft(5, '0')}';

  SubscriptionPeriodStatus get periodStatus {
    final today = AppDateUtils.today();
    if (today.isBefore(AppDateUtils.dateOnly(periodStart))) {
      return SubscriptionPeriodStatus.scheduled;
    }
    if (today.isAfter(AppDateUtils.dateOnly(periodEnd))) {
      return SubscriptionPeriodStatus.completed;
    }
    return SubscriptionPeriodStatus.active;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plan_id': planId,
        'plan_name': planName,
        'action': action.name,
        'period_start': periodStart.toIso8601String(),
        'period_end': periodEnd.toIso8601String(),
        'amount': amount,
        'payment_id': paymentId,
        'created_at': createdAt.toIso8601String(),
      };

  factory SubscriptionRecord.fromJson(Map<String, dynamic> json) {
    return SubscriptionRecord(
      id: json['id'].toString(),
      planId: json['plan_id'].toString(),
      planName: json['plan_name'] as String,
      action: SubscriptionAction.values.byName(json['action'] as String),
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      amount: (json['amount'] as num).toDouble(),
      paymentId: json['payment_id'].toString(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

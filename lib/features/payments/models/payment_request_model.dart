import '../../../core/utils/app_formatters.dart';
import '../../booking/models/facility_model.dart';
import '../../subscriptions/models/membership_plan_model.dart';
import '../../subscriptions/models/subscription_model.dart';
import 'payment_model.dart';

/// A booking the user picked but has not paid for yet.
/// The real [Booking] is only created after a successful payment.
class BookingDraft {
  const BookingDraft({
    required this.facility,
    required this.date,
    required this.timeSlot,
  });

  final Facility facility;
  final DateTime date;
  final String timeSlot;

  double get price => facility.pricePerHour;
}

/// Everything the Payment screen needs to charge the user.
/// Passed as the route argument of [AppRoutes.payment].
class PaymentRequest {
  const PaymentRequest._({
    required this.purpose,
    required this.itemName,
    required this.description,
    required this.amount,
    required this.details,
    this.plan,
    this.booking,
  });

  factory PaymentRequest.membership({
    required MembershipPlan plan,
    required SubscriptionAction action,
    required DateTime startDate,
    required DateTime newExpiry,
  }) {
    return PaymentRequest._(
      purpose: action == SubscriptionAction.renewal
          ? PaymentPurpose.renewal
          : PaymentPurpose.membership,
      itemName: '${plan.name} Membership',
      description: action.label,
      amount: plan.price,
      plan: plan,
      details: {
        'Plan': plan.name,
        'Duration': plan.durationLabel,
        'Type': action.label,
        'Starts': AppFormatters.date(startDate),
        'New Expiry': AppFormatters.date(newExpiry),
      },
    );
  }

  factory PaymentRequest.booking(BookingDraft draft) {
    return PaymentRequest._(
      purpose: PaymentPurpose.booking,
      itemName: draft.facility.name,
      description: 'Facility Booking',
      amount: draft.price,
      booking: draft,
      details: {
        'Facility': draft.facility.name,
        'Date': AppFormatters.date(draft.date),
        'Time': draft.timeSlot,
        'Duration': '1 hour',
      },
    );
  }

  final PaymentPurpose purpose;
  final String itemName;
  final String description;
  final double amount;

  /// Ordered label/value pairs shown in the order summary.
  final Map<String, String> details;

  final MembershipPlan? plan;
  final BookingDraft? booking;
}

/// Card data typed by the user. Only lives in memory during checkout.
class PaymentCardDetails {
  const PaymentCardDetails({
    required this.holderName,
    required this.number,
    required this.expiry,
    required this.cvv,
  });

  final String holderName;
  final String number;
  final String expiry;
  final String cvv;

  String get digits => number.replaceAll(RegExp(r'\D'), '');

  String get last4 =>
      digits.length >= 4 ? digits.substring(digits.length - 4) : digits;

  String get brand {
    if (digits.startsWith('4')) return 'Visa';
    if (RegExp(r'^5[1-5]').hasMatch(digits) ||
        RegExp(r'^2[2-7]').hasMatch(digits)) {
      return 'Mastercard';
    }
    if (digits.startsWith('507803') || digits.startsWith('507808')) {
      return 'Meeza';
    }
    return 'Card';
  }
}

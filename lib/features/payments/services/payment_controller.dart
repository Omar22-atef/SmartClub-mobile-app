import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_formatters.dart';
import '../../booking/models/booking_model.dart';
import '../../booking/services/booking_mock_service.dart';
import '../../notifications/models/notification_model.dart';
import '../../notifications/services/notification_controller.dart';
import '../../subscriptions/models/subscription_model.dart';
import '../../subscriptions/services/membership_controller.dart';
import '../models/payment_model.dart';
import '../models/payment_request_model.dart';

/// Result returned to the Payment screen.
class PaymentResult {
  const PaymentResult.success(Payment this.payment) : errorMessage = null;

  const PaymentResult.failure(String this.errorMessage, {this.payment});

  final Payment? payment;
  final String? errorMessage;

  bool get isSuccess => errorMessage == null;
}

/// Simulates a payment gateway and keeps the payment history.
///
/// After a successful payment it also:
/// - activates / renews the membership (MembershipController)
/// - creates the booking (BookingMockService)
/// - pushes an in-app notification (NotificationController)
///
/// Backend phase: replace the body of [processPayment] with an API call
/// (e.g. `POST /payments`) and keep the same method signature so the UI
/// does not change.
class PaymentController extends ChangeNotifier {
  PaymentController._() {
    _seedMockData();
  }

  static final PaymentController instance = PaymentController._();

  /// Demo cards (shown on the Payment screen).
  static const String successTestCard = '4242 4242 4242 4242';
  static const String declinedTestCard = '4000 0000 0000 0002';

  static const Duration _processingDelay = Duration(seconds: 2);

  final List<Payment> _payments = [];
  final Random _random = Random();
  int _nextSequence = 1050;
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  /// Newest first.
  List<Payment> get payments => List.unmodifiable(_payments);

  double get totalPaid => _payments
      .where((p) => p.status == PaymentStatus.successful)
      .fold(0.0, (sum, p) => sum + p.amount);

  Payment? findById(String id) {
    for (final payment in _payments) {
      if (payment.id == id) return payment;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Checkout
  // ---------------------------------------------------------------------------

  Future<PaymentResult> processPayment({
    required PaymentRequest request,
    required PaymentMethod method,
    required String payerName,
    PaymentCardDetails? card,
    String? walletNumber,
  }) async {
    if (_isProcessing) {
      return const PaymentResult.failure(
        'A payment is already being processed.',
      );
    }
    if (method == PaymentMethod.creditCard && card == null) {
      return const PaymentResult.failure('Please enter your card details.');
    }

    _isProcessing = true;
    notifyListeners();

    try {
      // Simulated network / bank delay.
      await Future<void>.delayed(_processingDelay);

      // The slot may have been taken while the user was on this screen.
      final draft = request.booking;
      if (draft != null &&
          BookingMockService().isSlotBooked(
            draft.facility.id,
            draft.date,
            draft.timeSlot,
          )) {
        return const PaymentResult.failure(
          'This time slot is no longer available. '
          'Please go back and choose another slot.',
        );
      }

      final accountDigits = method == PaymentMethod.creditCard
          ? card!.digits
          : (walletNumber ?? '').replaceAll(RegExp(r'\D'), '');
      final last4 = accountDigits.length >= 4
          ? accountDigits.substring(accountDigits.length - 4)
          : accountDigits;
      final sequence = _nextSequence++;
      final paymentId = 'PAY-$sequence';

      // Simulated decline.
      if (method == PaymentMethod.creditCard &&
          card!.digits == declinedTestCard.replaceAll(' ', '')) {
        const reason = 'Your card was declined by the bank. '
            'Please try another card.';
        final failed = _buildPayment(
          id: paymentId,
          sequence: sequence,
          request: request,
          method: method,
          last4: last4,
          cardBrand: card!.brand,
          payerName: payerName,
          status: PaymentStatus.failed,
          failureReason: reason,
        );
        _payments.insert(0, failed);
        NotificationController.instance.push(
          title: 'Payment failed',
          body: 'Your payment of ${AppFormatters.currency(request.amount)} '
              'for ${request.itemName} was declined.',
          type: NotificationType.payment,
          route: AppRoutes.paymentHistory,
        );
        return PaymentResult.failure(reason, payment: failed);
      }

      final referenceId = _fulfil(request, paymentId);

      final payment = _buildPayment(
        id: paymentId,
        sequence: sequence,
        request: request,
        method: method,
        last4: last4,
        cardBrand: method == PaymentMethod.creditCard ? card!.brand : null,
        payerName: payerName,
        status: PaymentStatus.successful,
        referenceId: referenceId,
      );
      _payments.insert(0, payment);
      _notifySuccess(payment);

      return PaymentResult.success(payment);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Marks the payment linked to [referenceId] as refunded
  /// (used when a paid booking is cancelled).
  void refundByReference(String referenceId) {
    final index = _payments.indexWhere(
      (p) =>
          p.referenceId == referenceId && p.status == PaymentStatus.successful,
    );
    if (index == -1) return;

    final refunded = _payments[index].copyWith(status: PaymentStatus.refunded);
    _payments[index] = refunded;
    notifyListeners();

    NotificationController.instance.push(
      title: 'Refund issued',
      body: '${AppFormatters.currency(refunded.amount)} for '
          '${refunded.itemName} will be returned to ${refunded.methodLabel}.',
      type: NotificationType.payment,
      route: AppRoutes.paymentHistory,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Applies what the user paid for and returns its reference id.
  String _fulfil(PaymentRequest request, String paymentId) {
    final plan = request.plan;
    if (plan != null) {
      final record = MembershipController.instance.activate(
        plan: plan,
        paymentId: paymentId,
      );
      return record.referenceId;
    }

    final draft = request.booking;
    if (draft != null) {
      final booking = BookingMockService().addBooking(
        facilityId: draft.facility.id,
        facilityName: draft.facility.name,
        date: draft.date,
        timeSlot: draft.timeSlot,
        pricePerHour: draft.facility.pricePerHour,
      );
      return booking.referenceId;
    }

    return paymentId;
  }

  void _notifySuccess(Payment payment) {
    final notifications = NotificationController.instance;

    if (payment.purpose.isMembership) {
      final membership = MembershipController.instance.membership;
      final expiry = membership != null
          ? AppFormatters.date(membership.expiryDate)
          : '-';
      notifications.push(
        title: payment.purpose == PaymentPurpose.renewal
            ? 'Membership renewed'
            : 'Membership activated',
        body: 'Payment of ${AppFormatters.currency(payment.amount)} received. '
            'Your ${payment.itemName} is valid until $expiry.',
        type: NotificationType.membership,
        route: AppRoutes.subscriptionDetails,
      );
    } else {
      notifications.push(
        title: 'Booking confirmed',
        body: '${payment.itemName} is booked. '
            'Paid ${AppFormatters.currency(payment.amount)} '
            '(${payment.referenceId}).',
        type: NotificationType.booking,
        route: AppRoutes.myBookings,
      );
    }
  }

  Payment _buildPayment({
    required String id,
    required int sequence,
    required PaymentRequest request,
    required PaymentMethod method,
    required String last4,
    required String payerName,
    required PaymentStatus status,
    String? cardBrand,
    String? referenceId,
    String? failureReason,
    DateTime? createdAt,
  }) {
    final date = createdAt ?? DateTime.now();
    return Payment(
      id: id,
      receiptNumber:
          'RCPT-${date.year}-${sequence.toString().padLeft(6, '0')}',
      transactionId: 'TXN${100000000 + _random.nextInt(900000000)}',
      purpose: request.purpose,
      itemName: request.itemName,
      description: request.description,
      amount: request.amount,
      method: method,
      accountLast4: last4,
      cardBrand: cardBrand,
      payerName: payerName,
      createdAt: date,
      status: status,
      referenceId: referenceId,
      failureReason: failureReason,
    );
  }

  // ---------------------------------------------------------------------------
  // Mock data (matches the seeded membership history and bookings)
  // ---------------------------------------------------------------------------

  void _seedMockData() {
    const payer = 'Club Member';
    var sequence = 1001;

    // Membership payments.
    final history = MembershipController.instance.history.reversed;
    for (final record in history) {
      final purpose = record.action == SubscriptionAction.renewal
          ? PaymentPurpose.renewal
          : PaymentPurpose.membership;
      _payments.add(
        Payment(
          id: record.paymentId,
          receiptNumber: 'RCPT-${record.createdAt.year}-'
              '${(sequence++).toString().padLeft(6, '0')}',
          transactionId: 'TXN${100000000 + _random.nextInt(900000000)}',
          purpose: purpose,
          itemName: '${record.planName} Membership',
          description: record.action.label,
          amount: record.amount,
          method: PaymentMethod.creditCard,
          accountLast4: '4242',
          cardBrand: 'Visa',
          payerName: payer,
          createdAt: record.createdAt,
          status: PaymentStatus.successful,
          referenceId: record.referenceId,
        ),
      );
    }

    // Booking payments.
    final now = DateTime.now();
    for (final booking in BookingMockService().bookings) {
      var paidAt = booking.date
          .subtract(const Duration(days: 3))
          .add(const Duration(hours: 14));
      if (paidAt.isAfter(now)) {
        paidAt = now.subtract(const Duration(days: 1, hours: 2));
      }
      _payments.add(
        Payment(
          id: 'PAY-${sequence + 20}',
          receiptNumber: 'RCPT-${paidAt.year}-'
              '${(sequence++).toString().padLeft(6, '0')}',
          transactionId: 'TXN${100000000 + _random.nextInt(900000000)}',
          purpose: PaymentPurpose.booking,
          itemName: booking.facilityName,
          description: 'Facility Booking',
          amount: booking.totalPrice,
          method: PaymentMethod.mobileWallet,
          accountLast4: '0192',
          payerName: payer,
          createdAt: paidAt,
          status: booking.status == BookingStatus.cancelled
              ? PaymentStatus.refunded
              : PaymentStatus.successful,
          referenceId: booking.referenceId,
        ),
      );
    }

    _payments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

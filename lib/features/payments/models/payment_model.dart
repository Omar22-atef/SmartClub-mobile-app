import 'package:flutter/material.dart';

import '../../../core/utils/app_formatters.dart';

/// What the payment was for.
enum PaymentPurpose {
  membership('Membership'),
  renewal('Renewal'),
  booking('Booking');

  const PaymentPurpose(this.label);
  final String label;

  bool get isMembership => this != PaymentPurpose.booking;
}

enum PaymentMethod {
  creditCard('Credit / Debit Card', Icons.credit_card),
  mobileWallet('Mobile Wallet', Icons.account_balance_wallet_outlined);

  const PaymentMethod(this.label, this.icon);
  final String label;
  final IconData icon;
}

enum PaymentStatus {
  successful('Paid'),
  failed('Failed'),
  refunded('Refunded');

  const PaymentStatus(this.label);
  final String label;
}

/// A saved payment (successful, failed or refunded). Also used as the receipt.
class Payment {
  const Payment({
    required this.id,
    required this.receiptNumber,
    required this.transactionId,
    required this.purpose,
    required this.itemName,
    required this.description,
    required this.amount,
    required this.method,
    required this.accountLast4,
    required this.payerName,
    required this.createdAt,
    required this.status,
    this.cardBrand,
    this.referenceId,
    this.failureReason,
  });

  final String id;
  final String receiptNumber;
  final String transactionId;
  final PaymentPurpose purpose;
  final String itemName;
  final String description;
  final double amount;
  final PaymentMethod method;

  /// Last 4 digits of the card or wallet number. Full numbers are never stored.
  final String accountLast4;
  final String? cardBrand;
  final String payerName;
  final DateTime createdAt;
  final PaymentStatus status;

  /// Booking reference (BK-...) or subscription reference (SUB-...).
  final String? referenceId;
  final String? failureReason;

  bool get hasReceipt => status != PaymentStatus.failed;

  String get methodLabel {
    switch (method) {
      case PaymentMethod.creditCard:
        return '${cardBrand ?? 'Card'} •••• $accountLast4';
      case PaymentMethod.mobileWallet:
        return 'Wallet •••• $accountLast4';
    }
  }

  Payment copyWith({PaymentStatus? status}) {
    return Payment(
      id: id,
      receiptNumber: receiptNumber,
      transactionId: transactionId,
      purpose: purpose,
      itemName: itemName,
      description: description,
      amount: amount,
      method: method,
      accountLast4: accountLast4,
      cardBrand: cardBrand,
      payerName: payerName,
      createdAt: createdAt,
      status: status ?? this.status,
      referenceId: referenceId,
      failureReason: failureReason,
    );
  }

  /// Plain-text receipt (used by "Copy Receipt").
  String toReceiptText() {
    final lines = <String>[
      'SMART CLUB — PAYMENT RECEIPT',
      '----------------------------------',
      'Receipt No:   $receiptNumber',
      'Transaction:  $transactionId',
      'Date:         ${AppFormatters.dateTime(createdAt)}',
      'Paid for:     $itemName',
      'Type:         $description',
      if (referenceId != null) 'Reference:    $referenceId',
      'Method:       $methodLabel',
      'Payer:        $payerName',
      'Status:       ${status.label}',
      '----------------------------------',
      'TOTAL:        ${AppFormatters.currency(amount)}',
    ];
    return lines.join('\n');
  }

  // ---------------------------------------------------------------------------
  // JSON (ready for the backend phase)
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'id': id,
        'receipt_number': receiptNumber,
        'transaction_id': transactionId,
        'purpose': purpose.name,
        'item_name': itemName,
        'description': description,
        'amount': amount,
        'method': method.name,
        'account_last4': accountLast4,
        'card_brand': cardBrand,
        'payer_name': payerName,
        'created_at': createdAt.toIso8601String(),
        'status': status.name,
        'reference_id': referenceId,
        'failure_reason': failureReason,
      };

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'].toString(),
      receiptNumber: json['receipt_number'] as String,
      transactionId: json['transaction_id'] as String,
      purpose: PaymentPurpose.values.byName(json['purpose'] as String),
      itemName: json['item_name'] as String,
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num).toDouble(),
      method: PaymentMethod.values.byName(json['method'] as String),
      accountLast4: json['account_last4'] as String? ?? '',
      cardBrand: json['card_brand'] as String?,
      payerName: json['payer_name'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      status: PaymentStatus.values.byName(json['status'] as String),
      referenceId: json['reference_id'] as String?,
      failureReason: json['failure_reason'] as String?,
    );
  }
}

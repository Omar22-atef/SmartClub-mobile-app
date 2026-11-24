import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/summary_row.dart';
import '../models/payment_model.dart';

/// Printable-looking receipt generated from a [Payment].
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({super.key, required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final isRefunded = payment.status == PaymentStatus.refunded;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header strip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: AppSpacing.itemSpacing,
            ),
            decoration: const BoxDecoration(
              color: AppColors.midnightBlack,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'SMART CLUB',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.limeNeon,
                  ),
                ),
                const Spacer(),
                Text(
                  'PAYMENT RECEIPT',
                  style: AppTextStyles.labelCaps.copyWith(
                    color: AppColors.pureWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              children: [
                SummaryRow(label: 'Receipt No.', value: payment.receiptNumber),
                SummaryRow(label: 'Transaction ID', value: payment.transactionId),
                SummaryRow(
                  label: 'Date',
                  value: AppFormatters.dateTime(payment.createdAt),
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                const _DashedDivider(),
                const SizedBox(height: AppSpacing.spaceSm),
                SummaryRow(label: 'Paid for', value: payment.itemName),
                SummaryRow(label: 'Type', value: payment.description),
                if (payment.referenceId != null)
                  SummaryRow(label: 'Reference', value: payment.referenceId!),
                SummaryRow(label: 'Method', value: payment.methodLabel),
                SummaryRow(label: 'Payer', value: payment.payerName),
                SummaryRow(
                  label: 'Status',
                  value: payment.status.label,
                  valueColor:
                      isRefunded ? AppColors.warning : AppColors.secondary,
                  bold: true,
                ),
                const SizedBox(height: AppSpacing.spaceSm),
                const _DashedDivider(),
                const SizedBox(height: AppSpacing.itemSpacing),
                Row(
                  children: [
                    Text(
                      isRefunded ? 'Total Refunded' : 'Total Paid',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppFormatters.currency(payment.amount),
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.midnightBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const gap = 4.0;
        final count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => const SizedBox(
              width: dashWidth,
              height: 1,
              child: ColoredBox(color: AppColors.outlineVariant),
            ),
          ),
        );
      },
    );
  }
}

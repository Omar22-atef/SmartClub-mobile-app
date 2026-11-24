import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/summary_row.dart';
import '../models/payment_model.dart';
import '../models/payment_request_model.dart';

/// "What am I paying for" card at the top of the Payment screen.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.request});

  final PaymentRequest request;

  IconData get _icon {
    switch (request.purpose) {
      case PaymentPurpose.membership:
        return Icons.card_membership_outlined;
      case PaymentPurpose.renewal:
        return Icons.autorenew;
      case PaymentPurpose.booking:
        return request.booking?.facility.icon ?? Icons.event_available;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.midnightBlack,
                    borderRadius: AppRadius.medium,
                  ),
                  child: Icon(_icon, color: AppColors.limeNeon),
                ),
                const SizedBox(width: AppSpacing.itemSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.itemName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        request.description,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.itemSpacing),
            const Divider(),
            const SizedBox(height: AppSpacing.spaceSm),
            ...request.details.entries.map(
              (entry) => SummaryRow(label: entry.key, value: entry.value),
            ),
            const SizedBox(height: AppSpacing.spaceSm),
            const Divider(),
            const SizedBox(height: AppSpacing.spaceSm),
            Row(
              children: [
                Text(
                  'Total',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  AppFormatters.currency(request.amount),
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
    );
  }
}

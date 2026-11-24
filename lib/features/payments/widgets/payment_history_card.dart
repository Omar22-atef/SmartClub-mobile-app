import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/status_pill.dart';
import '../models/payment_model.dart';

Color paymentStatusColor(PaymentStatus status) {
  switch (status) {
    case PaymentStatus.successful:
      return AppColors.secondary;
    case PaymentStatus.failed:
      return AppColors.error;
    case PaymentStatus.refunded:
      return AppColors.warning;
  }
}

IconData _purposeIcon(PaymentPurpose purpose) {
  switch (purpose) {
    case PaymentPurpose.membership:
      return Icons.card_membership_outlined;
    case PaymentPurpose.renewal:
      return Icons.autorenew;
    case PaymentPurpose.booking:
      return Icons.event_available_outlined;
  }
}

class PaymentHistoryCard extends StatelessWidget {
  const PaymentHistoryCard({
    super.key,
    required this.payment,
    required this.onTap,
  });

  final Payment payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFailed = payment.status == PaymentStatus.failed;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: AppRadius.medium,
                ),
                child: Icon(
                  _purposeIcon(payment.purpose),
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.itemSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${payment.purpose.label} • '
                      '${AppFormatters.date(payment.createdAt)}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      payment.methodLabel,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.spaceSm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppFormatters.currency(payment.amount),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: isFailed
                          ? AppColors.textMuted
                          : AppColors.midnightBlack,
                      decoration: isFailed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),
                  StatusPill(
                    label: payment.status.label,
                    color: paymentStatusColor(payment.status),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

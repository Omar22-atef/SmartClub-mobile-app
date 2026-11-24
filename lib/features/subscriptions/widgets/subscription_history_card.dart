import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../shared/widgets/status_pill.dart';
import '../models/subscription_model.dart';

Color _periodStatusColor(SubscriptionPeriodStatus status) {
  switch (status) {
    case SubscriptionPeriodStatus.active:
      return AppColors.secondary;
    case SubscriptionPeriodStatus.scheduled:
      return AppColors.warning;
    case SubscriptionPeriodStatus.completed:
      return AppColors.outline;
  }
}

IconData _actionIcon(SubscriptionAction action) {
  switch (action) {
    case SubscriptionAction.newSubscription:
      return Icons.add_card_outlined;
    case SubscriptionAction.renewal:
      return Icons.autorenew;
    case SubscriptionAction.planChange:
      return Icons.swap_horiz;
  }
}

/// One subscription period in the membership history.
class SubscriptionHistoryCard extends StatelessWidget {
  const SubscriptionHistoryCard({
    super.key,
    required this.record,
    this.onTap,
  });

  final SubscriptionRecord record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final periodStatus = record.periodStatus;
    final isActive = periodStatus == SubscriptionPeriodStatus.active;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.midnightBlack
                          : AppColors.surfaceContainerHigh,
                      borderRadius: AppRadius.medium,
                    ),
                    child: Icon(
                      _actionIcon(record.action),
                      size: 20,
                      color: isActive
                          ? AppColors.limeNeon
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${record.planName} Membership',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          record.action.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusPill(
                    label: periodStatus.label,
                    color: _periodStatusColor(periodStatus),
                    showDot: isActive,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              const Divider(),
              const SizedBox(height: AppSpacing.itemSpacing),
              Row(
                children: [
                  const Icon(
                    Icons.date_range_outlined,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  Expanded(
                    child: Text(
                      '${AppFormatters.date(record.periodStart)}  →  '
                      '${AppFormatters.date(record.periodEnd)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              Row(
                children: [
                  Text(
                    record.referenceId,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppFormatters.currency(record.amount),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.midnightBlack,
                    ),
                  ),
                  if (onTap != null) ...[
                    const SizedBox(width: AppSpacing.spaceXs),
                    const Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../models/subscription_model.dart';

/// Status color on light surfaces.
Color membershipStatusColor(MembershipStatus status) {
  switch (status) {
    case MembershipStatus.active:
      return AppColors.secondary;
    case MembershipStatus.expiringSoon:
      return AppColors.warning;
    case MembershipStatus.expired:
      return AppColors.error;
    case MembershipStatus.none:
      return AppColors.textMuted;
  }
}

/// Status color on the dark membership card.
Color _darkStatusColor(MembershipStatus status) {
  switch (status) {
    case MembershipStatus.active:
      return AppColors.limeNeon;
    case MembershipStatus.expiringSoon:
      return AppColors.warningContainer;
    case MembershipStatus.expired:
      return AppColors.errorContainer;
    case MembershipStatus.none:
      return AppColors.textMuted;
  }
}

/// Dark "digital membership card" showing plan, status, expiry and progress.
class MembershipStatusCard extends StatelessWidget {
  const MembershipStatusCard({
    super.key,
    required this.membership,
    this.onTap,
    this.onRenew,
  });

  final Membership? membership;
  final VoidCallback? onTap;

  /// Shown as a "Renew Now" button when the membership is expiring/expired.
  final VoidCallback? onRenew;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spaceLg - 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: AppRadius.large,
          border: const Border.fromBorderSide(AppEffects.darkHairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.limeNeon.withValues(alpha: 0.10),
                ),
              ),
            ),
            membership == null
                ? _buildEmpty()
                : _buildMembership(membership!),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SMART CLUB',
          style: AppTextStyles.labelCaps.copyWith(color: AppColors.limeNeon),
        ),
        const SizedBox(height: AppSpacing.itemSpacing),
        Text(
          'No active membership',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.pureWhite,
          ),
        ),
        const SizedBox(height: AppSpacing.spaceXs),
        Text(
          'Choose a plan below to unlock full club access.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.pureWhite.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMembership(Membership m) {
    final status = m.status;
    final statusColor = _darkStatusColor(status);
    final daysLeft = m.daysRemaining < 0 ? 0 : m.daysRemaining;
    final showRenew = onRenew != null &&
        (status == MembershipStatus.expiringSoon ||
            status == MembershipStatus.expired);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'SMART CLUB MEMBER',
                style: AppTextStyles.labelCaps.copyWith(
                  color: AppColors.limeNeon,
                ),
              ),
            ),
            Container(
              height: AppDimensions.statusPillHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spaceSm,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.18),
                borderRadius: AppRadius.pill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppDimensions.statusDotSize,
                    height: AppDimensions.statusDotSize,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status.label.toUpperCase(),
                    style: AppTextStyles.labelCaps.copyWith(
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.itemSpacing),
        Text(
          '${m.plan.name} Membership',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.pureWhite,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${m.memberCardNumber}  •  Member since '
          '${AppFormatters.date(m.memberSince)}',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.pureWhite.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),
        ClipRRect(
          borderRadius: AppRadius.pill,
          child: LinearProgressIndicator(
            value: m.periodProgress,
            minHeight: 6,
            backgroundColor: AppColors.pureWhite.withValues(alpha: 0.12),
            color: statusColor,
          ),
        ),
        const SizedBox(height: AppSpacing.itemSpacing),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: status == MembershipStatus.expired
                    ? 'EXPIRED ON'
                    : 'VALID UNTIL',
                value: AppFormatters.date(m.expiryDate),
              ),
            ),
            _Metric(
              label: 'DAYS LEFT',
              value: '$daysLeft',
              alignEnd: true,
            ),
          ],
        ),
        if (showRenew) ...[
          const SizedBox(height: AppSpacing.spaceMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onRenew,
              icon: const Icon(Icons.autorenew, size: 20),
              label: const Text('Renew Now'),
            ),
          ),
        ] else if (onTap != null) ...[
          const SizedBox(height: AppSpacing.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'View details',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.pureWhite.withValues(alpha: 0.7),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.pureWhite.withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelCaps.copyWith(
            color: AppColors.pureWhite.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/guest_pass_model.dart';

class PassHistoryCard extends StatelessWidget {
  const PassHistoryCard({
    super.key,
    required this.record,
    this.onTap,
  });

  final GuestPassRecord record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCompleted = record.status == GuestPassStatus.completed;

    return Material(
      color: AppColors.surfaceLight,
      borderRadius: AppRadius.medium,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: AppRadius.medium,
            border: Border.fromBorderSide(AppEffects.lightHairline),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.surfaceMuted
                          : AppColors.limeNeon.withValues(alpha: 0.20),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      record.initials,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isCompleted
                            ? AppColors.onSurface
                            : AppColors.surfaceDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.itemSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.guestName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          record.subtitle,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spaceSm),
                  _StatusBadge(status: record.status),
                  if (onTap != null) ...[
                    const SizedBox(width: AppSpacing.spaceXs),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
              const Divider(
                color: AppColors.surfaceContainer,
                height: 1,
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              Row(
                children: [
                  const Icon(
                    Icons.qr_code_2,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Pass Code: ${record.passCode}',
                    style: AppTextStyles.labelCaps.copyWith(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final GuestPassStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == GuestPassStatus.completed) {
      return Container(
        height: AppDimensions.statusPillHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: AppRadius.pill,
        ),
        alignment: Alignment.center,
        child: Text(
          'Completed',
          style: AppTextStyles.labelCaps.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }

    return Container(
      height: AppDimensions.statusPillHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.limeNeon.withValues(alpha: 0.20),
        borderRadius: AppRadius.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.statusDotSize,
            height: AppDimensions.statusDotSize,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.spaceXs),
          Text(
            'Active',
            style: AppTextStyles.labelCaps.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
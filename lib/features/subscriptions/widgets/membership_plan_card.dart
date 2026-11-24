import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_formatters.dart';
import '../models/membership_plan_model.dart';

/// Selectable membership plan card (name, price, savings, features).
class MembershipPlanCard extends StatelessWidget {
  const MembershipPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
    this.isCurrent = false,
    this.savings = 0,
    this.showFeatures = true,
  });

  final MembershipPlan plan;
  final bool isSelected;
  final bool isCurrent;
  final double savings;
  final bool showFeatures;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected ? AppColors.midnightBlack : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? AppEffects.limeActiveGlow : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (plan.isPopular || isCurrent) ...[
              Wrap(
                spacing: AppSpacing.spaceSm,
                children: [
                  if (plan.isPopular)
                    const _Tag(
                      label: 'MOST POPULAR',
                      background: AppColors.limeNeon,
                      foreground: AppColors.midnightBlack,
                    ),
                  if (isCurrent)
                    const _Tag(
                      label: 'CURRENT PLAN',
                      background: AppColors.midnightBlack,
                      foreground: AppColors.limeNeon,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.itemSpacing),
            ],
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.midnightBlack
                        : AppColors.surfaceContainerHigh,
                    borderRadius: AppRadius.medium,
                  ),
                  child: Icon(
                    plan.icon,
                    color: isSelected
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
                        plan.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        plan.tagline,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                _SelectionIndicator(isSelected: isSelected),
              ],
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppFormatters.currency(plan.price),
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.midnightBlack,
                  ),
                ),
                const SizedBox(width: AppSpacing.spaceXs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '/ ${plan.durationLabel}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const Spacer(),
                if (savings > 0)
                  _Tag(
                    label: 'SAVE ${AppFormatters.currency(savings)}',
                    background: AppColors.secondary.withValues(alpha: 0.1),
                    foreground: AppColors.secondary,
                  ),
              ],
            ),
            if (plan.durationMonths > 1) ...[
              const SizedBox(height: 2),
              Text(
                '≈ ${AppFormatters.currency(plan.monthlyPrice.roundToDouble())} / month',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
            if (showFeatures) ...[
              const SizedBox(height: AppSpacing.itemSpacing),
              const Divider(),
              const SizedBox(height: AppSpacing.spaceSm),
              ...plan.features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: isSelected
                            ? AppColors.secondary
                            : AppColors.textMuted,
                      ),
                      const SizedBox(width: AppSpacing.spaceSm),
                      Expanded(
                        child: Text(
                          feature,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.midnightBlack : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.midnightBlack : AppColors.outlineVariant,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 16, color: AppColors.limeNeon)
          : null,
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.pill,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelCaps.copyWith(color: foreground),
      ),
    );
  }
}

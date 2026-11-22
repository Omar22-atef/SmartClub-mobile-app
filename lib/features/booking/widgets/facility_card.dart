import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/facility_model.dart';

class FacilityCard extends StatelessWidget {
  final Facility facility;
  final VoidCallback onTap;

  const FacilityCard({
    super.key,
    required this.facility,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHigh,
              ),
              child: Center(
                child: Icon(
                  facility.icon,
                  size: 48,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & availability row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spaceSm,
                          vertical: AppSpacing.spaceXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: AppRadius.small,
                        ),
                        child: Text(
                          facility.categoryLabel,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: AppDimensions.statusDotSize,
                        height: AppDimensions.statusDotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: facility.isAvailable
                              ? AppColors.secondary
                              : AppColors.error,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.spaceXs),
                      Text(
                        facility.isAvailable ? 'Available' : 'Unavailable',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: facility.isAvailable
                              ? AppColors.secondary
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.spaceSm),

                  // Name
                  Text(
                    facility.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.spaceXs),

                  // Description
                  Text(
                    facility.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.spaceSm),

                  // Price & rating row
                  Row(
                    children: [
                      Text(
                        '\$${facility.pricePerHour.toStringAsFixed(0)}/hr',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.midnightBlack,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.limeNeon,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        facility.rating.toString(),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

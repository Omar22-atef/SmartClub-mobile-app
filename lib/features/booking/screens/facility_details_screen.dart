import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/facility_model.dart';
import '../../../core/routes/app_routes.dart';

class FacilityDetailsScreen extends StatelessWidget {
  final Facility facility;

  const FacilityDetailsScreen({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Banner image
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surfaceContainerHigh,
                child: Center(
                  child: Icon(
                    facility.icon,
                    size: 80,
                    color: AppColors.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & category
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          facility.name,
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
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
                    ],
                  ),

                  const SizedBox(height: AppSpacing.spaceSm),

                  // Availability
                  Row(
                    children: [
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
                        facility.isAvailable
                            ? 'Currently Available'
                            : 'Currently Unavailable',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: facility.isAvailable
                              ? AppColors.secondary
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Text(
                    facility.longDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Info cards
                  _InfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: facility.location,
                  ),
                  _InfoTile(
                    icon: Icons.schedule_outlined,
                    label: 'Operating Hours',
                    value: facility.operatingHours,
                  ),
                  _InfoTile(
                    icon: Icons.attach_money_outlined,
                    label: 'Price',
                    value:
                        '\$${facility.pricePerHour.toStringAsFixed(0)} / hour',
                  ),
                  _InfoTile(
                    icon: Icons.people_outline,
                    label: 'Capacity',
                    value: '${facility.capacity} people',
                  ),
                  _InfoTile(
                    icon: Icons.timer_outlined,
                    label: 'Booking Duration',
                    value: facility.bookingDuration,
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Equipment
                  Text(
                    'Equipment & Amenities',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Wrap(
                    spacing: AppSpacing.spaceSm,
                    runSpacing: AppSpacing.spaceSm,
                    children: [
                      ...facility.equipment
                          .map((e) => _ChipTag(label: e)),
                      ...facility.amenities
                          .map((a) => _ChipTag(label: a)),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Rules
                  Text(
                    'Rules & Instructions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  ...facility.rules.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.spaceXs,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: AppSpacing.spaceSm),
                          Expanded(
                            child: Text(
                              r,
                              style:
                                  theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.space2xl),
                ],
              ),
            ),
          ),
        ],
      ),

      // Book now button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: ElevatedButton(
            onPressed: facility.isAvailable
                ? () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.bookFacility,
                      arguments: facility,
                    );
                  }
                : null,
            child: Text(
              facility.isAvailable
                  ? 'Book Now'
                  : 'Currently Unavailable',
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spaceMd),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.medium,
            ),
            child: Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipTag extends StatelessWidget {
  final String label;
  const _ChipTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSm + 2,
        vertical: AppSpacing.spaceXs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

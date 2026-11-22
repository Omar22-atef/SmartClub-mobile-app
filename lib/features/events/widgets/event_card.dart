import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final ClubEvent event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
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
            // Cover image placeholder
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerHigh,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      event.icon,
                      size: 48,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  // Category badge
                  Positioned(
                    top: AppSpacing.spaceSm,
                    left: AppSpacing.spaceSm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spaceSm,
                        vertical: AppSpacing.spaceXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.midnightBlack.withOpacity(0.75),
                        borderRadius: AppRadius.small,
                      ),
                      child: Text(
                        event.categoryLabel,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),
                  // Seats badge
                  Positioned(
                    top: AppSpacing.spaceSm,
                    right: AppSpacing.spaceSm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spaceSm,
                        vertical: AppSpacing.spaceXs,
                      ),
                      decoration: BoxDecoration(
                        color: event.isFull
                            ? AppColors.error.withOpacity(0.9)
                            : AppColors.secondary.withOpacity(0.9),
                        borderRadius: AppRadius.small,
                      ),
                      child: Text(
                        event.isFull
                            ? 'Full'
                            : '${event.remainingSeats} seats left',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.spaceXs),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  // Date, time, location
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _formatDate(event.date),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.location,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  String _formatDate(DateTime d) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month]} ${d.day}, ${d.year}';
  }
}

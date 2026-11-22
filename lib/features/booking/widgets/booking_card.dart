import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/booking_model.dart';

Color _statusColor(BookingStatus status) {
  switch (status) {
    case BookingStatus.upcoming:
      return AppColors.secondary;
    case BookingStatus.completed:
      return AppColors.onSurfaceVariant;
    case BookingStatus.cancelled:
      return AppColors.error;
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onCancel;

  const BookingCard({
    super.key,
    required this.booking,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: facility name + status
            Row(
              children: [
                Expanded(
                  child: Text(
                    booking.facilityName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StatusPill(status: booking.status),
              ],
            ),

            const SizedBox(height: AppSpacing.spaceSm),
            const Divider(),
            const SizedBox(height: AppSpacing.spaceSm),

            // Info rows
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              text: _formatDate(booking.date),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            _InfoRow(
              icon: Icons.access_time_outlined,
              text: booking.timeSlot,
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            _InfoRow(icon: Icons.timer_outlined, text: booking.duration),
            const SizedBox(height: AppSpacing.spaceSm),

            // Footer: ref + price + cancel
            Row(
              children: [
                Text(
                  booking.referenceId,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${booking.totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.midnightBlack,
                  ),
                ),
              ],
            ),

            if (booking.status == BookingStatus.upcoming &&
                onCancel != null) ...[
              const SizedBox(height: AppSpacing.spaceSm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Cancel Booking'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
            ],
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

class _StatusPill extends StatelessWidget {
  final BookingStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      height: AppDimensions.statusPillHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.pill,
      ),
      alignment: Alignment.center,
      child: Text(
        status == BookingStatus.upcoming
            ? 'Upcoming'
            : status == BookingStatus.completed
                ? 'Completed'
                : 'Cancelled',
        style: AppTextStyles.labelMedium.copyWith(color: color),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.spaceSm),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/event_registration_model.dart';

Color _regStatusColor(RegistrationStatus status) {
  switch (status) {
    case RegistrationStatus.upcoming:
      return AppColors.secondary;
    case RegistrationStatus.completed:
      return AppColors.onSurfaceVariant;
    case RegistrationStatus.cancelled:
      return AppColors.error;
  }
}

class EventRegistrationCard extends StatelessWidget {
  final EventRegistration registration;
  final VoidCallback? onCancel;
  final VoidCallback? onTap;

  const EventRegistrationCard({
    super.key,
    required this.registration,
    this.onCancel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.large,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      registration.eventTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _RegStatusPill(status: registration.status),
                ],
              ),
              const SizedBox(height: AppSpacing.spaceSm),
              const Divider(),
              const SizedBox(height: AppSpacing.spaceSm),

              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: _formatDate(registration.eventDate),
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              _InfoRow(
                icon: Icons.access_time_outlined,
                text: registration.eventTime,
              ),
              const SizedBox(height: AppSpacing.spaceXs),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: registration.eventLocation,
              ),
              const SizedBox(height: AppSpacing.spaceSm),

              Row(
                children: [
                  Text(
                    registration.referenceId,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),

              if (registration.status == RegistrationStatus.upcoming &&
                  onCancel != null) ...[
                const SizedBox(height: AppSpacing.spaceSm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Cancel Registration'),
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

class _RegStatusPill extends StatelessWidget {
  final RegistrationStatus status;
  const _RegStatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _regStatusColor(status);
    return Container(
      height: AppDimensions.statusPillHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spaceSm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.pill,
      ),
      alignment: Alignment.center,
      child: Text(
        status == RegistrationStatus.upcoming
            ? 'Upcoming'
            : status == RegistrationStatus.completed
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
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

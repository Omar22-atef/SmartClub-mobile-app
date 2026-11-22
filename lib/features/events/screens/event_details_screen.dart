import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/event_model.dart';
import '../models/event_registration_model.dart';
import '../services/event_mock_service.dart';
import '../services/event_mock_data.dart';
import 'my_events_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final ClubEvent event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventMockService _eventService = EventMockService();

  bool get _isRegistered => _eventService.isRegistered(widget.event.id);

  void _register() {
    if (widget.event.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This event is full. Registration is closed.'),
        ),
      );
      return;
    }
    if (widget.event.hasPassed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This event has already passed.'),
        ),
      );
      return;
    }

    final registration = _eventService.registerForEvent(widget.event);
    setState(() {});

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.secondary),
            ),
            const SizedBox(width: AppSpacing.spaceSm),
            const Expanded(child: Text('Registration Confirmed!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You have successfully registered for this event.',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            _DetailRow(
              label: 'Reference',
              value: registration.referenceId,
            ),
            _DetailRow(
              label: 'Event',
              value: widget.event.title,
            ),
            _DetailRow(
              label: 'Date',
              value: _formatDate(widget.event.date),
            ),
            _DetailRow(
              label: 'Time',
              value: widget.event.time,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyEventsScreen(),
                ),
              );
            },
            child: const Text('View My Events'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _cancelRegistration() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: const Text('Cancel Registration?'),
        content: Text(
          'Are you sure you want to cancel your registration for ${widget.event.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Registration'),
          ),
          ElevatedButton(
            onPressed: () {
              final regIndex = _eventService.registrations.indexWhere(
                (r) =>
                    r.eventId == widget.event.id &&
                    r.status != RegistrationStatus.cancelled,
              );
              if (regIndex != -1) {
                final reg = _eventService.registrations[regIndex];
                _eventService.cancelRegistration(reg.id, mockEvents);
              }
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration cancelled successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
            ),
            child: const Text('Cancel Registration'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = widget.event;

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.surfaceContainerHigh,
                child: Center(
                  child: Icon(
                    event.icon,
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
                  // Title & category
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
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
                          event.categoryLabel,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Info tiles
                  _InfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: _formatDate(event.date),
                  ),
                  _InfoTile(
                    icon: Icons.access_time_outlined,
                    label: 'Time',
                    value: event.time,
                  ),
                  _InfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: event.location,
                  ),
                  _InfoTile(
                    icon: Icons.person_outline,
                    label: 'Organizer',
                    value: event.organizer,
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Description
                  Text(
                    'About This Event',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),
                  Text(
                    event.fullDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.spaceLg),

                  // Capacity section
                  Text(
                    'Capacity & Registration',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spaceSm),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.cardPadding),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _CapStat(
                                label: 'Max Capacity',
                                value: '${event.maxCapacity}',
                              ),
                              _CapStat(
                                label: 'Registered',
                                value: '${event.registeredCount}',
                              ),
                              _CapStat(
                                label: 'Remaining',
                                value: '${event.remainingSeats}',
                                highlight: event.remainingSeats <= 5,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.spaceSm),
                          // Progress bar
                          ClipRRect(
                            borderRadius: AppRadius.pill,
                            child: LinearProgressIndicator(
                              value:
                                  event.registeredCount / event.maxCapacity,
                              minHeight: 8,
                              backgroundColor: AppColors.surfaceContainerHigh,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                event.isFull
                                    ? AppColors.error
                                    : AppColors.limeNeon,
                              ),
                            ),
                          ),
                          if (event.registrationDeadline case final deadline?) ...[
                            const SizedBox(height: AppSpacing.spaceSm),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Registration deadline: ${_formatDate(deadline)}',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
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

      // Registration button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: _isRegistered
              ? OutlinedButton(
                  onPressed: _cancelRegistration,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size(0, 56),
                  ),
                  child: const Text('Cancel Registration'),
                )
              : ElevatedButton(
                  onPressed:
                      (event.isFull || event.hasPassed) ? null : _register,
                  child: Text(
                    event.isFull
                        ? 'Event Full'
                        : event.hasPassed
                            ? 'Event Passed'
                            : 'Register for Event',
                  ),
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

class _CapStat extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _CapStat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            color: highlight ? AppColors.error : AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spaceXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

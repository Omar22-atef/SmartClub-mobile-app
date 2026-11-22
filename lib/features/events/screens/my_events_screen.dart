import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/event_registration_model.dart';
import '../services/event_mock_service.dart';
import '../services/event_mock_data.dart';
import '../widgets/event_registration_card.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final EventMockService _eventService = EventMockService();
  RegistrationStatus? _selectedFilter;

  Widget _buildFilterChip(String label, RegistrationStatus? status) {
    final isSelected = _selectedFilter == status;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.spaceSm),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: isSelected
              ? AppColors.midnightBlack
              : AppColors.onSurfaceVariant,
        ),
        backgroundColor: AppColors.surfaceMuted,
        selectedColor: AppColors.limeNeon,
        checkmarkColor: AppColors.midnightBlack,
        side: BorderSide(
          color: isSelected ? AppColors.limeNeon : AppColors.borderLight,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.pill),
        onSelected: (_) => setState(() => _selectedFilter = status),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.spaceSm,
      ),
      child: SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          children: [
            _buildFilterChip('All', null),
            _buildFilterChip(
              'Upcoming',
              RegistrationStatus.upcoming,
            ),
            _buildFilterChip(
              'Completed',
              RegistrationStatus.completed,
            ),
            _buildFilterChip(
              'Cancelled',
              RegistrationStatus.cancelled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.gutter * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'No event registrations',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            Text(
              'Your event registrations will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registrations =
        _eventService.getFilteredRegistrations(_selectedFilter);
    final totalItems = registrations.isEmpty ? 2 : registrations.length + 1;

    return Scaffold(
      appBar: AppBar(title: const Text('My Events')),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }

          if (registrations.isEmpty) {
            return _buildEmptyState(theme);
          }

          final reg = registrations[index - 1];
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.itemSpacing,
            ),
            child: EventRegistrationCard(
              registration: reg,
              onCancel: reg.status == RegistrationStatus.upcoming
                  ? () => _showCancelDialog(reg)
                  : null,
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog(EventRegistration reg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: const Text('Cancel Registration?'),
        content: Text(
          'Are you sure you want to cancel your registration for ${reg.eventTitle}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Registration'),
          ),
          ElevatedButton(
            onPressed: () {
              _eventService.cancelRegistration(reg.id, mockEvents);
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
}

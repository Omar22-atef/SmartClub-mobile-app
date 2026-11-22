import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/event_model.dart';
import '../services/event_mock_data.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  EventCategory _selectedCategory = EventCategory.all;
  String _searchQuery = '';

  List<ClubEvent> get _filteredEvents {
    return mockEvents.where((e) {
      final matchesCategory = _selectedCategory == EventCategory.all ||
          e.category == _selectedCategory;
      final matchesSearch =
          e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHeader(ThemeData theme, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textMuted,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),

        // Category chips using horizontal ListView.builder
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.gutter,
            ),
            itemCount: EventCategory.values.length,
            itemBuilder: (context, index) {
              final cat = EventCategory.values[index];
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.spaceSm),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(cat.label),
                  labelStyle: AppTextStyles.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.midnightBlack
                        : AppColors.onSurfaceVariant,
                  ),
                  backgroundColor: AppColors.surfaceMuted,
                  selectedColor: AppColors.limeNeon,
                  checkmarkColor: AppColors.midnightBlack,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.limeNeon
                        : AppColors.borderLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.pill,
                  ),
                  onSelected: (_) =>
                      setState(() => _selectedCategory = cat),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          child: Text(
            '$count ${count == 1 ? 'Event' : 'Events'} Scheduled',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceSm),
      ],
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
              Icons.event_busy_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'No events found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            Text(
              'Try adjusting your search or category filters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredEvents;
    final totalItems = filtered.isEmpty ? 2 : filtered.length + 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Club Events')),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader(theme, filtered.length);
          }

          if (filtered.isEmpty) {
            return _buildEmptyState(theme);
          }

          final event = filtered[index - 1];
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.itemSpacing,
            ),
            child: EventCard(
              event: event,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailsScreen(event: event),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
          );
        },
      ),
    );
  }
}

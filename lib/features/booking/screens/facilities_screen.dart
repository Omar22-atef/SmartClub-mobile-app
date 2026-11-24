import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/facility_model.dart';
import '../services/facility_mock_data.dart';
import '../widgets/facility_card.dart';
import '../../../core/routes/app_routes.dart';
import '../../notifications/widgets/notification_bell_button.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  FacilityCategory _selectedCategory = FacilityCategory.all;
  String _searchQuery = '';

  List<Facility> get _filteredFacilities {
    return mockFacilities.where((f) {
      final matchesCategory = _selectedCategory == FacilityCategory.all ||
          f.category == _selectedCategory;
      final matchesSearch =
          f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              f.description
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
        // Welcome message
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          child: Text(
            'Explore and book our premium club facilities',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spaceMd),

        // Search field
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Search facilities...',
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

        // Category filter chips using ListView.builder
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.gutter,
            ),
            itemCount: FacilityCategory.values.length,
            itemBuilder: (context, index) {
              final cat = FacilityCategory.values[index];
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

        // Count subtitle
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gutter,
          ),
          child: Text(
            '$count ${count == 1 ? 'Facility' : 'Facilities'} Available',
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
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'No facilities found',
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
    final filtered = _filteredFacilities;
    final totalItems = filtered.isEmpty ? 2 : filtered.length + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facilities'),
        actions: const [
          NotificationBellButton(),
          SizedBox(width: AppSpacing.spaceXs),
        ],
      ),
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

          final facility = filtered[index - 1];
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.itemSpacing,
            ),
            child: FacilityCard(
              facility: facility,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.facilityDetails,
                  arguments: facility,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

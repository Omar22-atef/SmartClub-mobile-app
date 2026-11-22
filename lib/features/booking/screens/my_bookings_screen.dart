import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/booking_model.dart';
import '../services/booking_mock_service.dart';
import '../widgets/booking_card.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final BookingMockService _bookingService = BookingMockService();
  BookingStatus? _selectedFilter;

  Widget _buildFilterChip(String label, BookingStatus? status) {
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
            _buildFilterChip('Upcoming', BookingStatus.upcoming),
            _buildFilterChip('Completed', BookingStatus.completed),
            _buildFilterChip('Cancelled', BookingStatus.cancelled),
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
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            Text(
              'No bookings found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceXs),
            Text(
              'Your bookings will appear here',
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
    final bookings = _bookingService.getFilteredBookings(_selectedFilter);
    final totalItems = bookings.isEmpty ? 2 : bookings.length + 1;

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }

          if (bookings.isEmpty) {
            return _buildEmptyState(theme);
          }

          final booking = bookings[index - 1];
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.itemSpacing,
            ),
            child: BookingCard(
              booking: booking,
              onCancel: booking.status == BookingStatus.upcoming
                  ? () => _showCancelDialog(booking)
                  : null,
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog(Booking booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: const Text('Cancel Booking?'),
        content: Text(
          'Are you sure you want to cancel your booking for ${booking.facilityName} on ${_formatDate(booking.date)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              _bookingService.cancelBooking(booking.id);
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
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

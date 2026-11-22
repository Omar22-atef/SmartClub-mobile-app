import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../models/facility_model.dart';
import '../services/booking_mock_service.dart';
import '../../../core/routes/app_routes.dart';

class BookingScreen extends StatefulWidget {
  final Facility facility;

  const BookingScreen({super.key, required this.facility});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingMockService _bookingService = BookingMockService();

  late DateTime _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _allTimeSlots = [
    '09:00 AM – 10:00 AM',
    '10:00 AM – 11:00 AM',
    '11:00 AM – 12:00 PM',
    '01:00 PM – 02:00 PM',
    '02:00 PM – 03:00 PM',
    '04:00 PM – 05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = _today();
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSlotAvailable(String slot) {
    final dayOffset = _selectedDate.difference(_today()).inDays;
    if (dayOffset == 0 && slot == '09:00 AM – 10:00 AM') return false;
    if (dayOffset == 1 && slot == '01:00 PM – 02:00 PM') return false;

    return !_bookingService.isSlotBooked(
      widget.facility.id,
      _selectedDate,
      slot,
    );
  }

  void _confirmBooking() {
    final slotToBook = _selectedTimeSlot;
    if (slotToBook == null) return;

    final booking = _bookingService.addBooking(
      facilityId: widget.facility.id,
      facilityName: widget.facility.name,
      date: _selectedDate,
      timeSlot: slotToBook,
      pricePerHour: widget.facility.pricePerHour,
    );

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
            const Expanded(child: Text('Booking Confirmed!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your booking has been confirmed successfully.',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.spaceMd),
            _SummaryRow(
              label: 'Reference',
              value: booking.referenceId,
            ),
            _SummaryRow(
              label: 'Facility',
              value: booking.facilityName,
            ),
            _SummaryRow(
              label: 'Date',
              value: _formatDate(booking.date),
            ),
            _SummaryRow(
              label: 'Time',
              value: booking.timeSlot,
            ),
            _SummaryRow(
              label: 'Total',
              value: '\$${booking.totalPrice.toStringAsFixed(0)}',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.myBookings,
              );
            },
            child: const Text('View My Bookings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );

    setState(() {
      _selectedTimeSlot = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Facility')),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.gutter,
          AppSpacing.gutter,
          AppSpacing.space2xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Facility summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: AppRadius.medium,
                      ),
                      child: Icon(
                        widget.facility.icon,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.facility.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${widget.facility.pricePerHour.toStringAsFixed(0)} / hour',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.spaceLg),

            // Date selection
            Text(
              'Select Date',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),

            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 14,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.spaceSm),
                itemBuilder: (context, index) {
                  final date = _today().add(Duration(days: index));
                  final isSelected = date == _selectedDate;
                  const dayNames = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  final dayName = dayNames[date.weekday - 1];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _selectedTimeSlot = null;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.midnightBlack
                            : AppColors.surfaceMuted,
                        borderRadius: AppRadius.medium,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.midnightBlack
                              : AppColors.borderLight,
                        ),
                        boxShadow:
                            isSelected ? AppEffects.limeActiveGlow : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected
                                  ? AppColors.limeNeon
                                  : AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: isSelected
                                  ? AppColors.pureWhite
                                  : AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppSpacing.spaceLg),

            // Time slots
            Text(
              'Select Time Slot',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceSm),

            Wrap(
              spacing: AppSpacing.spaceSm,
              runSpacing: AppSpacing.spaceSm,
              children: _allTimeSlots.map((slot) {
                final available = _isSlotAvailable(slot);
                final isSelected = _selectedTimeSlot == slot;

                return GestureDetector(
                  onTap: available
                      ? () => setState(() => _selectedTimeSlot = slot)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spaceMd,
                      vertical: AppSpacing.spaceSm + 2,
                    ),
                    decoration: BoxDecoration(
                      color: !available
                          ? AppColors.disabledBackground
                          : isSelected
                              ? AppColors.midnightBlack
                              : AppColors.pureWhite,
                      borderRadius: AppRadius.medium,
                      border: Border.all(
                        color: !available
                            ? AppColors.borderLight
                            : isSelected
                                ? AppColors.midnightBlack
                                : AppColors.borderLight,
                      ),
                      boxShadow:
                          isSelected ? AppEffects.limeActiveGlow : null,
                    ),
                    child: Text(
                      slot,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: !available
                            ? AppColors.disabledForeground
                            : isSelected
                                ? AppColors.limeNeon
                                : AppColors.onSurface,
                        decoration:
                            !available ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.spaceLg),

            // Booking summary
            if (_selectedTimeSlot case final slot?) ...[
              Text(
                'Booking Summary',
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
                      _SummaryRow(
                        label: 'Facility',
                        value: widget.facility.name,
                      ),
                      _SummaryRow(
                        label: 'Date',
                        value: _formatDate(_selectedDate),
                      ),
                      _SummaryRow(
                        label: 'Time',
                        value: slot,
                      ),
                      const _SummaryRow(
                        label: 'Duration',
                        value: '1 hour',
                      ),
                      const Divider(),
                      _SummaryRow(
                        label: 'Total Price',
                        value:
                            '\$${widget.facility.pricePerHour.toStringAsFixed(0)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.spaceLg),
          ],
        ),
      ),

      // Confirm button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: ElevatedButton(
            onPressed: _selectedTimeSlot != null ? _confirmBooking : null,
            child: const Text('Confirm Booking'),
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

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
          Text(
            value,
            style: bold
                ? AppTextStyles.labelLarge.copyWith(
                    color: AppColors.midnightBlack,
                  )
                : AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
          ),
        ],
      ),
    );
  }
}

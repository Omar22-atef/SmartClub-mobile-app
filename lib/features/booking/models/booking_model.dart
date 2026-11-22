enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  final String id;
  final String facilityId;
  final String facilityName;
  final DateTime date;
  final String timeSlot;
  final String duration;
  final double totalPrice;
  BookingStatus status;

  Booking({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.date,
    required this.timeSlot,
    required this.duration,
    required this.totalPrice,
    required this.status,
  });

  String get referenceId => 'BK-${id.padLeft(6, '0')}';

  String get statusLabel {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Upcoming';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class TimeSlot {
  final String label;
  final bool isAvailable;

  const TimeSlot({required this.label, required this.isAvailable});
}

import '../models/booking_model.dart';

class BookingMockService {
  static final BookingMockService _instance = BookingMockService._internal();
  factory BookingMockService() => _instance;
  BookingMockService._internal() {
    _initMockBookings();
  }

  final List<Booking> _bookings = [];

  /// Pre-booked slots: key = "facilityId_yyyy-MM-dd", value = set of time labels
  final Map<String, Set<String>> _bookedSlots = {};

  int _nextId = 100;

  List<Booking> get bookings => List.unmodifiable(_bookings);

  void _initMockBookings() {
    final now = DateTime.now();
    _bookings.addAll([
      Booking(
        id: '001',
        facilityId: '1',
        facilityName: 'Football Court',
        date: now.add(const Duration(days: 2)),
        timeSlot: '10:00 AM – 11:00 AM',
        duration: '1 hour',
        totalPrice: 120.0,
        status: BookingStatus.upcoming,
      ),
      Booking(
        id: '002',
        facilityId: '4',
        facilityName: 'Swimming Pool',
        date: now.subtract(const Duration(days: 5)),
        timeSlot: '09:00 AM – 10:00 AM',
        duration: '1 hour',
        totalPrice: 60.0,
        status: BookingStatus.completed,
      ),
      Booking(
        id: '003',
        facilityId: '2',
        facilityName: 'Tennis Court',
        date: now.subtract(const Duration(days: 3)),
        timeSlot: '02:00 PM – 03:00 PM',
        duration: '1 hour',
        totalPrice: 80.0,
        status: BookingStatus.cancelled,
      ),
    ]);

    // Mark existing upcoming booking slot as booked
    final dateKey = '1_${_formatDate(now.add(const Duration(days: 2)))}';
    final slots = _bookedSlots.putIfAbsent(dateKey, () => <String>{});
    slots.add('10:00 AM – 11:00 AM');
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool isSlotBooked(String facilityId, DateTime date, String timeSlot) {
    final key = '${facilityId}_${_formatDate(date)}';
    return _bookedSlots[key]?.contains(timeSlot) ?? false;
  }

  Booking addBooking({
    required String facilityId,
    required String facilityName,
    required DateTime date,
    required String timeSlot,
    required double pricePerHour,
  }) {
    final key = '${facilityId}_${_formatDate(date)}';
    final slots = _bookedSlots.putIfAbsent(key, () => <String>{});
    slots.add(timeSlot);

    final booking = Booking(
      id: (_nextId++).toString(),
      facilityId: facilityId,
      facilityName: facilityName,
      date: date,
      timeSlot: timeSlot,
      duration: '1 hour',
      totalPrice: pricePerHour,
      status: BookingStatus.upcoming,
    );
    _bookings.insert(0, booking);
    return booking;
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final booking = _bookings[index];
      booking.status = BookingStatus.cancelled;

      // Free the slot
      final key = '${booking.facilityId}_${_formatDate(booking.date)}';
      _bookedSlots[key]?.remove(booking.timeSlot);
    }
  }

  List<Booking> getFilteredBookings(BookingStatus? status) {
    if (status == null) return bookings;
    return _bookings.where((b) => b.status == status).toList();
  }
}

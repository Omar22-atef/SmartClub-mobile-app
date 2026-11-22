enum RegistrationStatus { upcoming, completed, cancelled }

class EventRegistration {
  final String id;
  final String eventId;
  final String eventTitle;
  final DateTime eventDate;
  final String eventTime;
  final String eventLocation;
  RegistrationStatus status;

  EventRegistration({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.status,
  });

  String get referenceId => 'EV-${id.padLeft(6, '0')}';

  String get statusLabel {
    switch (status) {
      case RegistrationStatus.upcoming:
        return 'Upcoming';
      case RegistrationStatus.completed:
        return 'Completed';
      case RegistrationStatus.cancelled:
        return 'Cancelled';
    }
  }
}

import '../models/event_model.dart';
import '../models/event_registration_model.dart';

class EventMockService {
  static final EventMockService _instance = EventMockService._internal();
  factory EventMockService() => _instance;
  EventMockService._internal();

  final List<EventRegistration> _registrations = [];

  int _nextId = 200;

  List<EventRegistration> get registrations =>
      List.unmodifiable(_registrations);

  bool isRegistered(String eventId) {
    return _registrations.any(
      (r) =>
          r.eventId == eventId && r.status != RegistrationStatus.cancelled,
    );
  }

  EventRegistration registerForEvent(ClubEvent event) {
    event.registeredCount++;

    final registration = EventRegistration(
      id: (_nextId++).toString(),
      eventId: event.id,
      eventTitle: event.title,
      eventDate: event.date,
      eventTime: event.time,
      eventLocation: event.location,
      status: RegistrationStatus.upcoming,
    );
    _registrations.insert(0, registration);
    return registration;
  }

  void cancelRegistration(String registrationId, List<ClubEvent> events) {
    final reg = _registrations.firstWhere((r) => r.id == registrationId);
    reg.status = RegistrationStatus.cancelled;

    // Restore capacity
    final event = events.firstWhere((e) => e.id == reg.eventId);
    if (event.registeredCount > 0) {
      event.registeredCount--;
    }
  }

  List<EventRegistration> getFilteredRegistrations(
    RegistrationStatus? status,
  ) {
    if (status == null) return registrations;
    return _registrations.where((r) => r.status == status).toList();
  }
}

import 'package:flutter/material.dart';

import '../../features/booking/models/facility_model.dart';
import '../../features/booking/screens/booking_screen.dart';
import '../../features/booking/screens/facilities_screen.dart';
import '../../features/booking/screens/facility_details_screen.dart';
import '../../features/booking/screens/my_bookings_screen.dart';
import '../../features/events/models/event_model.dart';
import '../../features/events/screens/event_details_screen.dart';
import '../../features/events/screens/events_screen.dart';
import '../../features/events/screens/my_events_screen.dart';
import '../../features/guests/models/guest_pass_model.dart';
import '../../features/guests/screens/create_guest_pass_screen.dart';
import '../../features/guests/screens/guest_pass_ticket_screen.dart';
import '../../features/guests/screens/guest_passes_hub_screen.dart';
import '../constants/app_constants.dart';
import '../widgets/main_shell_screen.dart';

class CreateGuestPassArgs {
  const CreateGuestPassArgs({
    required this.remainingPasses,
    required this.nextSequence,
  });

  final int remainingPasses;
  final int nextSequence;
}

class GuestPassTicketArgs {
  const GuestPassTicketArgs({
    required this.record,
    this.isNewlyIssued = false,
  });

  final GuestPassRecord record;
  final bool isNewlyIssued;
}

class AppRoutes {
  AppRoutes._();

  // Shell
  static const String home = '/';

  // Booking
  static const String facilities = '/facilities';
  static const String facilityDetails = '/facilities/details';
  static const String bookFacility = '/facilities/book';
  static const String myBookings = '/my-bookings';

  // Events
  static const String events = '/events';
  static const String eventDetails = '/events/details';
  static const String myEvents = '/my-events';

  // Guests
  static const String guestPass = '/guest-pass';
  static const String createGuestPass = '/guest-pass/create';
  static const String guestPassTicket = '/guest-pass/ticket';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Shell
      case home:
        return _route(const MainShellScreen(), settings);

      // Booking
      case facilities:
        return _route(const FacilitiesScreen(), settings);

      case facilityDetails:
        if (args is! Facility) {
          return _errorRoute('Missing or invalid facility details.', settings);
        }
        return _route(FacilityDetailsScreen(facility: args), settings);

      case bookFacility:
        if (args is! Facility) {
          return _errorRoute('Missing or invalid facility to book.', settings);
        }
        return _route(BookingScreen(facility: args), settings);

      case myBookings:
        return _route(const MyBookingsScreen(), settings);

      // Events
      case events:
        return _route(const EventsScreen(), settings);

      case eventDetails:
        if (args is! ClubEvent) {
          return _errorRoute('Missing or invalid event details.', settings);
        }
        return _route(EventDetailsScreen(event: args), settings);

      case myEvents:
        return _route(const MyEventsScreen(), settings);

      // Guests
      case guestPass:
        return _route(const GuestPassesHubScreen(), settings);

      case createGuestPass:
        final passArgs = args is CreateGuestPassArgs ? args : null;
        return _route(
          CreateGuestPassScreen(
            remainingPasses: passArgs?.remainingPasses ?? 3,
            nextSequence: passArgs?.nextSequence ?? 9411,
          ),
          settings,
        );

      case guestPassTicket:
        if (args is! GuestPassTicketArgs) {
          return _errorRoute(
            'Missing or invalid guest pass ticket details.',
            settings,
          );
        }
        return _route(
          GuestPassTicketScreen(
            record: args.record,
            isNewlyIssued: args.isNewlyIssued,
          ),
          settings,
        );

      default:
        return _errorRoute(
          'Route "${settings.name}" is not registered.',
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _route(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => page,
    );
  }

  static MaterialPageRoute<dynamic> _errorRoute(
    String message,
    RouteSettings settings,
  ) {
    return _route(
      Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
      settings,
    );
  }
}
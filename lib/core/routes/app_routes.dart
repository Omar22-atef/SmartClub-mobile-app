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
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/payments/models/payment_model.dart';
import '../../features/payments/models/payment_request_model.dart';
import '../../features/payments/screens/payment_confirmation_screen.dart';
import '../../features/payments/screens/payment_history_screen.dart';
import '../../features/payments/screens/payment_screen.dart';
import '../../features/subscriptions/screens/membership_history_screen.dart';
import '../../features/subscriptions/screens/membership_plans_screen.dart';
import '../../features/subscriptions/screens/renewal_screen.dart';
import '../../features/subscriptions/screens/subscription_details_screen.dart';
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

/// Arguments for [AppRoutes.paymentConfirmation].
///
/// [isNewPayment] = true right after paying (success screen),
/// false when opening an old receipt from the payment history.
class PaymentReceiptArgs {
  const PaymentReceiptArgs({
    required this.payment,
    this.isNewPayment = false,
  });

  final Payment payment;
  final bool isNewPayment;
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

  // Subscriptions / Membership
  static const String membershipPlans = '/membership';
  static const String subscriptionDetails = '/membership/details';
  static const String renewal = '/membership/renew';
  static const String membershipHistory = '/membership/history';

  // Payments
  static const String payment = '/payment';
  static const String paymentConfirmation = '/payment/confirmation';
  static const String paymentHistory = '/payment/history';

  // Notifications
  static const String notifications = '/notifications';

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

      // Subscriptions / Membership
      case membershipPlans:
        return _route(const MembershipPlansScreen(), settings);

      case subscriptionDetails:
        return _route(const SubscriptionDetailsScreen(), settings);

      case renewal:
        return _route(const RenewalScreen(), settings);

      case membershipHistory:
        return _route(const MembershipHistoryScreen(), settings);

      // Payments
      case payment:
        if (args is! PaymentRequest) {
          return _errorRoute('Missing or invalid payment details.', settings);
        }
        return _route(PaymentScreen(request: args), settings);

      case paymentConfirmation:
        if (args is! PaymentReceiptArgs) {
          return _errorRoute('Missing or invalid receipt details.', settings);
        }
        return _route(
          PaymentConfirmationScreen(
            payment: args.payment,
            isNewPayment: args.isNewPayment,
          ),
          settings,
        );

      case paymentHistory:
        return _route(const PaymentHistoryScreen(), settings);

      // Notifications
      case notifications:
        return _route(const NotificationsScreen(), settings);

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
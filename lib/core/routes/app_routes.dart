import 'package:flutter/material.dart';
import '../../features/guests/models/guest_pass_model.dart';
import '../../features/guests/screens/create_guest_pass_screen.dart';
import '../../features/guests/screens/guest_pass_ticket_screen.dart';
import '../../features/guests/screens/guest_passes_hub_screen.dart';
import '../constants/app_constants.dart';

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

  // Guest Passes feature routes
  static const String guestPass = '/guest-pass';
  static const String createGuestPass = '/guest-pass/create';
  static const String guestPassTicket = '/guest-pass/ticket';

  // Teammates can add their route names here:
  // static const String login = '/login';
  // static const String booking = '/booking';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case guestPass:
        return MaterialPageRoute(
          builder: (_) => const GuestPassesHubScreen(),
        );

      case createGuestPass:
        final args = settings.arguments as CreateGuestPassArgs?;
        return MaterialPageRoute(
          builder: (_) => CreateGuestPassScreen(
            remainingPasses: args?.remainingPasses ?? 3,
            nextSequence: args?.nextSequence ?? 9411,
          ),
        );

      case guestPassTicket:
        final args = settings.arguments as GuestPassTicketArgs;
        return MaterialPageRoute(
          builder: (_) => GuestPassTicketScreen(
            record: args.record,
            isNewlyIssued: args.isNewlyIssued,
          ),
        );

      // Teammates can add their route cases here:
      // case booking:
      //   return MaterialPageRoute(builder: (_) => const BookingScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: AppColors.surface,
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Text(
                'Route "${settings.name}" is not registered.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
    }
  }
}
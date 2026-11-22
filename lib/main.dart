import 'dart:ui';
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/guests/screens/guest_passes_hub_screen.dart';
import 'features/events/models/event_model.dart';
import 'features/events/screens/event_details_screen.dart';
import 'features/events/screens/events_screen.dart';
import 'features/events/screens/my_events_screen.dart';
import 'features/events/services/event_mock_data.dart';
 import 'features/booking/screens/facilities_screen.dart';
 import 'features/booking/screens/my_bookings_screen.dart';
import 'features/events/screens/events_screen.dart';
 import 'features/events/screens/my_events_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Allows mouse drag scrolling on desktop, web, and emulators.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Club',
      theme: AppTheme.lightTheme,
      scrollBehavior: const AppScrollBehavior(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

class Member3ShowcaseScreen extends StatefulWidget {
  const Member3ShowcaseScreen({super.key});

  @override
  State<Member3ShowcaseScreen> createState() => _Member3ShowcaseScreenState();
}

class _Member3ShowcaseScreenState extends State<Member3ShowcaseScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FacilitiesScreen(),
    MyBookingsScreen(),
    EventsScreen(),
    MyEventsScreen(),
    GuestPassesHubScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer_outlined),
            activeIcon: Icon(Icons.sports_soccer),
            label: 'Facilities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg_outlined),
            activeIcon: Icon(Icons.how_to_reg),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge_outlined),
            activeIcon: Icon(Icons.badge),
            label: 'Guests',
          ),
        ],
      ),
    );
  }
}
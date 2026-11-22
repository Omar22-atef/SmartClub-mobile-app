import 'dart:ui';
import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/booking/models/facility_model.dart';
import 'features/booking/screens/booking_screen.dart';
import 'features/booking/screens/facilities_screen.dart';
import 'features/booking/screens/facility_details_screen.dart';
import 'features/booking/screens/my_bookings_screen.dart';
import 'features/booking/services/facility_mock_data.dart';
import 'features/events/models/event_model.dart';
import 'features/events/screens/event_details_screen.dart';
import 'features/events/screens/events_screen.dart';
import 'features/events/screens/my_events_screen.dart';
import 'features/events/services/event_mock_data.dart';

void main() {
  runApp(const MyApp());
}

/// Allows mouse drag scrolling on desktop, web, and emulators
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
      title: 'Smart Club - Member 3',
      theme: AppTheme.lightTheme,
      scrollBehavior: const AppScrollBehavior(),
      home: const Member3ShowcaseScreen(),
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
        ],
      ),
    );
  }
}



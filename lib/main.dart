import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Smart Club',
  theme: AppTheme.lightTheme,
  initialRoute: AppRoutes.guestPass,
  onGenerateRoute: AppRoutes.onGenerateRoute,
  );
  }
}


import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/admin/screens/admin_login_screen.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AdminLoginScreen(),
      ),
    );
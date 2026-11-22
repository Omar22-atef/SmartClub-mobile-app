
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  // ==========================================
  // LIGHT THEME
  // ==========================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Global colors and typography
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: AppColors.surface,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,

        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,

        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,

        error: AppColors.error,
        onError: AppColors.onError,

        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        surfaceContainerHighest:
            AppColors.surfaceContainerHighest,
        outline: AppColors.outline,
      ),

      // ========================================
      // TYPOGRAPHY
      // ========================================

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.statDisplay,

        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,

        titleLarge: AppTextStyles.headlineSmall,
        titleMedium: AppTextStyles.bodyLarge,
        titleSmall: AppTextStyles.labelLarge,

        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.labelMedium,

        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelCaps,
      ).apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.midnightBlack,
      ),

      // ========================================
      // APP BAR
      // ========================================

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.midnightBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.midnightBlack,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.midnightBlack,
          size: 24,
        ),
      ),

      // ========================================
      // PRIMARY BUTTONS
      // ========================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.limeNeon,
          foregroundColor: AppColors.midnightBlack,
          disabledBackgroundColor: AppColors.surfaceMuted,
          disabledForegroundColor: AppColors.textMuted,
          minimumSize: const Size(0, 56),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          elevation: 0,
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.pill,
          ),
        ),
      ),

      // ========================================
      // OUTLINED BUTTONS
      // ========================================

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.midnightBlack,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          side: const BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.pill,
          ),
        ),
      ),

      // ========================================
      // TEXT BUTTONS
      // ========================================

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.midnightBlack,
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.medium,
          ),
        ),
      ),

      // ========================================
      // TEXT FIELDS
      // ========================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
        ),

        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),

        errorStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.error,
        ),

        border: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: const BorderSide(
            color: AppColors.midnightBlack,
            width: 1.2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.large,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),

      // ========================================
      // CARDS
      // ========================================

      cardTheme: CardThemeData(
        color: AppColors.pureWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.large,
          side: const BorderSide(
            color: AppColors.borderLight,
            width: 1,
          ),
        ),
      ),

      // ========================================
      // BOTTOM NAVIGATION
      // ========================================

      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(
        backgroundColor: AppColors.midnightBlack,
        selectedItemColor: AppColors.limeNeon,
        unselectedItemColor: const Color(0xB3FFFFFF),
        elevation: 0,
        type: BottomNavigationBarType.fixed,

        selectedLabelStyle:
            AppTextStyles.labelMedium.copyWith(
          color: AppColors.limeNeon,
        ),

        unselectedLabelStyle:
            AppTextStyles.labelMedium.copyWith(
          color: const Color(0x14000000),
        ),
      ),

      // ========================================
      // ICONS
      // ========================================

      iconTheme: const IconThemeData(
        color: AppColors.midnightBlack,
        size: 24,
      ),

      // ========================================
      // DIVIDERS
      // ========================================

      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),

      // ========================================
      // SNACKBARS
      // ========================================

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.midnightBlack,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.pureWhite,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
        ),
      ),

      // ========================================
      // BOTTOM SHEETS
      // ========================================

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.pureWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      // ========================================
      // PROGRESS INDICATORS
      // ========================================

      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
        color: AppColors.limeNeon,
        linearTrackColor: AppColors.surfaceContainerHigh,
        circularTrackColor: AppColors.surfaceContainerHigh,
      ),
    );
  }
}

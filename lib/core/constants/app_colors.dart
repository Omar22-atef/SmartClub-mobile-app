import 'package:flutter/material.dart';

/// Kinetic Club / Smart Club color tokens.
/// Keep UI colors centralized here instead of hardcoding them in widgets.
class AppColors {
  AppColors._();

  // Core brand colors
  static const Color midnightBlack = Color(0xFF0B0B0C);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color limeNeon = Color(0xFFC6F432);
  static const Color limeMuted = Color(0xFFA8D61A);
  static const Color elevatedDark = Color(0xFF17181A);

  // Material-style surface tokens
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFD6DAE4);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF0F3FD);
  static const Color surfaceContainer = Color(0xFFEAEEF8);
  static const Color surfaceContainerHigh = Color(0xFFE5E8F2);
  static const Color surfaceContainerHighest = Color(0xFFDFE2EC);
  static const Color surfaceVariant = Color(0xFFDFE2EC);
  static const Color surfaceDark = Color(0xFF0B0B0C);
  static const Color surfaceDarkElevated = Color(0xFF17181A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF4F5F7);

  // Text and content colors
  static const Color onSurface = Color(0xFF171C23);
  static const Color onSurfaceVariant = Color(0xFF46464A);
  static const Color textMuted = Color(0xFF8E929B);
  static const Color inverseSurface = Color(0xFF2C3138);
  static const Color inverseOnSurface = Color(0xFFEDF1FB);

  // Primary, secondary, and tertiary tokens
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF1C1B1C);
  static const Color onPrimaryContainer = Color(0xFF858384);
  static const Color inversePrimary = Color(0xFFC8C6C7);

  static const Color secondary = Color(0xFF506600);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFC2F02E);
  static const Color onSecondaryContainer = Color(0xFF546B00);

  static const Color tertiary = Color(0xFF000000);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF1D1B19);
  static const Color onTertiaryContainer = Color(0xFF868380);

  // Error tokens
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Fixed palette tokens
  static const Color primaryFixed = Color(0xFFE5E2E3);
  static const Color primaryFixedDim = Color(0xFFC8C6C7);
  static const Color onPrimaryFixed = Color(0xFF1C1B1C);
  static const Color onPrimaryFixedVariant = Color(0xFF474647);

  static const Color secondaryFixed = Color(0xFFC5F331);
  static const Color secondaryFixedDim = Color(0xFFAAD600);
  static const Color onSecondaryFixed = Color(0xFF161F00);
  static const Color onSecondaryFixedVariant = Color(0xFF3B4D00);

  static const Color tertiaryFixed = Color(0xFFE7E2DD);
  static const Color tertiaryFixedDim = Color(0xFFCAC6C2);
  static const Color onTertiaryFixed = Color(0xFF1D1B19);
  static const Color onTertiaryFixedVariant = Color(0xFF494644);

  // Background and outline tokens
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF171C23);
  static const Color outline = Color(0xFF77777B);
  static const Color outlineVariant = Color(0xFFC7C6CA);
  static const Color surfaceTint = Color(0xFF5F5E5F);
  static const Color borderLight = Color(0xFFE2E4E8);

  // Alpha colors converted from the supplied RGBA values
  static const Color borderHairline = Color(0x140B0B0C); // 8% black
  static const Color borderDarkHairline = Color(0x1FFFFFFF); // 12% white
  static const Color limeGlow = Color(0x40C6F432); // 25% lime

  // Convenience aliases for common UI states
  static const Color active = limeNeon;
  static const Color selected = limeNeon;
  static const Color disabledBackground = surfaceMuted;
  static const Color disabledForeground = textMuted;
}

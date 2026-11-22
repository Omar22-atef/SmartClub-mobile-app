import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

/// Reusable effects specified by the Kinetic Club visual language.
class AppEffects {
  AppEffects._();

  /// Subtle lime aura for active actions and selected booking controls.
  static const List<BoxShadow> limeActiveGlow = [
    BoxShadow(
      color: AppColors.limeGlow,
      blurRadius: AppDimensions.limeGlowBlurRadius,
      spreadRadius: 0,
    ),
  ];

  /// A crisp hairline used on light surfaces.
  static const BorderSide lightHairline = BorderSide(
    color: AppColors.borderHairline,
    width: AppDimensions.borderWidth,
  );

  /// A subtle rim used around dark cards and containers.
  static const BorderSide darkHairline = BorderSide(
    color: AppColors.borderDarkHairline,
    width: AppDimensions.borderWidth,
  );
}

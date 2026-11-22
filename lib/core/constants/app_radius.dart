import 'package:flutter/widgets.dart';

/// Corner-radius tokens from the Kinetic Club design system.
class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double defaultRadius = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius standard =
      BorderRadius.all(Radius.circular(defaultRadius));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius extraLarge =
      BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(full));
}

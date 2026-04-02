import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color grey700 = Color.fromRGBO(97, 97, 97, 1); // Grey 700
  static const Color grey800 = Color.fromRGBO(66, 66, 66, 1); // Grey 800

  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static const Color primary = Color.fromARGB(255, 44, 156, 167); // Cyan
  static Color secondary(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;
  static Color onInverseSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onInverseSurface;
}

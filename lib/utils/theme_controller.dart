// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:synclist/utils/shared_preferences_controller.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.system,
  );

  static Future<void> init() async {
    String? currentTheme = await SharedPreferencesController().fetchTheme();
    if (currentTheme == null) {
      return;
    }

    if (currentTheme == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (currentTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
  }

  static void updateTheme(ThemeMode newTheme) {
    themeMode.value = newTheme;
    SharedPreferencesController().saveTheme(newTheme.name);
  }
}

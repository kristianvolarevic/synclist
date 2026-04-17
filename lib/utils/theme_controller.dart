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
    bool? isDark = await SharedPreferencesController().fetchTheme();
    if (isDark != null) {
      themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  static void toggleTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    SharedPreferencesController().saveTheme(isDark);
  }
}

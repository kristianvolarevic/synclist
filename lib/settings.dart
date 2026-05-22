// ----------------------------------------------------------------------------
// IMPORTS
// ----------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:synclist/authentication/welcome.dart';

// App Imports
import 'package:synclist/common_widgets/status_bar_page.dart';
import 'package:synclist/utils/theme_controller.dart';
import 'package:synclist/utils/utils.dart';
import 'package:synclist/common_widgets/warning_dialog.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void _signOut() async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          warningMessage: "Are you sure you want to sign out?",
        );
      },
    );

    if (confirmed == true) {
      FirebaseController().auth.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Welcome()),
        (route) => false,
      );
    }
  }

  void _showAbout() {
    showLicensePage(
      context: context,
      applicationLegalese: "@ 2026 Kristian Volarevic",
    );
  }

  void _clearData() async {
    try {
      final bool? confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            warningMessage: "Are you sure you want to clear app data?",
          );
        },
      );

      if (confirmed != true || !mounted) return;

      await SharedPreferencesController().clearSharedPreferences();

      if (!mounted) return;
      showMessage(context, "Data successfully cleared!");
    } catch (e) {
      if (!mounted) return;
      showMessage(context, "Unable to clear data: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: "Settings",
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
        child: Column(
          children: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.themeMode,
              builder: (context, themeMode, child) {
                return Row(
                  children: [
                    Text('Dark Mode', style: AppFonts.subHeadingText(context)),
                    const SizedBox(width: 12),
                    Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        ThemeController.toggleTheme(value);
                      },
                      activeThumbColor: AppColors.secondary(context),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Clear Data",
                        style: AppFonts.subHeadingText(context),
                      ),
                      Text(
                        "This will clear all data stored on your device, including: Custom category order, theme & item category.",
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _clearData,
                  style: TextButton.styleFrom(
                    textStyle: AppFonts.subHeadingText(context),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: Text("Clear Data"),
                ),
              ],
            ),
            Spacer(),

            ElevatedButton(
              onPressed: _showAbout,
              style: TextButton.styleFrom(
                textStyle: AppFonts.subHeadingText(context),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text("About"),
            ),

            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _signOut,
              style: TextButton.styleFrom(
                textStyle: AppFonts.subHeadingText(context),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}

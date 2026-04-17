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
    showLicensePage(context: context, applicationLegalese: "@ 2026 Kristian Volarevic");
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
            Row(
              children: [
                ElevatedButton(onPressed: _showAbout, child: Text("About")),
              ],
            ),
            Spacer(),
            ElevatedButton(onPressed: _signOut, child: Text("Sign Out")),
          ],
        ),
      ),
    );
  }
}

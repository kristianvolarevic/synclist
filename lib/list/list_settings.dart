// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/models/shopping_list.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LIST SETTINGS
// --------------------------------------------------------------------------------------------
class ListSettings extends StatefulWidget {
  final String listId;

  const ListSettings({super.key, required this.listId});

  @override
  State<ListSettings> createState() => _ListSettingsState();
}

// --------------------------------------------------------------------------------------------
// CLASS: LIST SETTINGS STATE
// --------------------------------------------------------------------------------------------
class _ListSettingsState extends State<ListSettings> {
  // ----------------- METHOD: HANDLE AUTOMATIC DELETION SWITCH ---------------
  void _handleAutomaticDeltionSwitch(ShoppingList list) async {
    print('test');
    try {
      await FirebaseController().updateList(list);
    } catch (e) {
      if (!mounted) return;
      showMessage(context, 'Unable to turn on/off automatic deletion.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: 'List Settings',
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: 20),
      ),
      body: StreamBuilder(
        stream: FirebaseController().streamSingleList(widget.listId),
        builder: (context, listSnapshot) {
          if (listSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: AppColors.primary);
          }

          if (!listSnapshot.hasData) return const SizedBox.shrink();

          final list = listSnapshot.data!;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Automatic Deletion',
                        style: AppFonts.blackSubHeadingText,
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: list.automaticDeletion,
                        onChanged: (val) {
                          list.automaticDeletion = val;
                          _handleAutomaticDeltionSwitch(list);
                        },
                        activeThumbColor: AppColors.contrast,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

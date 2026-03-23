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

  void _toggleShare(ShoppingList list) async {
    try {
      if (!list.isShared) {
        final code = await FirebaseController().generateUniqueCode(list);
      } else {
        await FirebaseController().deleteUniqueCode(list);
      }
    } catch (e) {
      if (!mounted) return;
      showMessage(context, "Error loading this page!");
    }
  }

  void _removeUser(String userId, String name) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove User"),
        content: Text("Are you sure you want to remove $name from this list?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await FirebaseController().removeUserFromList(
                  widget.listId,
                  userId,
                );
              } catch (e) {
                showMessage(context, "Could not remove user.");
              }
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
                  Row(
                    children: [
                      const Text(
                        "Share List",
                        style: AppFonts.blackSubHeadingText,
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: list.isShared,
                        activeThumbColor: AppColors.contrast,
                        onChanged: (val) {
                          _toggleShare(list);
                          setState(() => list.isShared = val);
                        },
                      ),
                    ],
                  ),
                  list.isShared
                      ? Row(
                          children: [
                            Text(
                              'Share ID: ${list.code}',
                              style: AppFonts.blackSubHeadingText,
                            ),
                          ],
                        )
                      : Row(),

                  const SizedBox(height: 20),
                  const Text(
                    "Joined Users",
                    style: AppFonts.blackSubHeadingText,
                  ),
                  const Divider(),
                  if (list.joinedUsers.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text("No one has joined this list yet."),
                    ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.joinedUsers.length,
                    itemBuilder: (context, index) {
                      final userId = list.joinedUsers[index];

                      return FutureBuilder(
                        future: FirebaseController().fetchUserDetails(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ListTile(
                              leading: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              title: Text("Loading..."),
                            );
                          }

                          final user = snapshot.data;
                          return ListTile(
                            leading: const Icon(Icons.person_outline, size: 25),
                            title: Text(
                              user!.fullName,
                              style: AppFonts.blackCardSubHeadingText,
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.person_remove_outlined,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  _removeUser(userId, user.fullName),
                            ),
                          );
                        },
                      );
                    },
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

// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';

class ListShare extends StatefulWidget {
  final String listId;

  const ListShare({super.key, required this.listId});

  @override
  State<ListShare> createState() => _ListShareState();
}

class _ListShareState extends State<ListShare> {
  bool _isLoading = false;

  void _toggleShare(ShoppingList list) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (!list.isShared) {
        final code = await FirebaseController().generateUniqueCode(list);
      } else {
        await FirebaseController().deleteUniqueCode(list);
      }
    } catch (e) {
      if (!mounted) return;
      showMessage(context, "Error loading this page!");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: "Share",
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, size: 20),
      ),
      body: Scaffold(
        body: StreamBuilder(
          stream: FirebaseController().streamSingleList(widget.listId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final list = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : list.isShared
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
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

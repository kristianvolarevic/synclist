// ----------------------------------------------------------------------------
// IMPORTS
// ----------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/common_widgets/list_card.dart';

// App Imports
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/models/user.dart';
import 'package:household_groceries/utils/utils.dart';

// ----------------------------------------------------------------------------
// CLASS: PROFILE
// ----------------------------------------------------------------------------
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: FirebaseController().userDetailsStream(
        FirebaseController().auth.currentUser!.uid,
      ),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: AppColors.primary);
        }

        if (!userSnapshot.hasData) return const SizedBox.shrink();

        final user = userSnapshot.data!;
        return StatusBarPage(
          title: user.fullName,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 20),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Icon(Icons.account_circle, size: 100)),
                const SizedBox(height: 16),
                const Text('Owned Lists', style: AppFonts.blackSubHeadingText),
                const Divider(),

                if (user.lists.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("No lists have been created yet."),
                  ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: user.lists.length,
                  itemBuilder: (context, index) {
                    final listId = user.lists[index];

                    return FutureBuilder(
                      future: FirebaseController().fetchListWithId(listId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LinearProgressIndicator(
                            color: AppColors.primary,
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final shoppingList = snapshot.data!;
                        return ListCard(list: shoppingList);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

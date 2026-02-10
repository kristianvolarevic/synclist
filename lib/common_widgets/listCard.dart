// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/list/listPage.dart';

// App Imports
import 'package:household_groceries/models/shoppingList.dart';
import 'package:household_groceries/utils/utils.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LIST CARD
// --------------------------------------------------------------------------------------------
class ListCard extends StatelessWidget {
  final ShoppingList list;

  const ListCard({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white38,
      child: ListTile(
        title: Text(list.name, style: AppFonts.blackCardHeaderText),
        subtitle: FutureBuilder(
          future: FirebaseController().fetchUserDetails(list.owner),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading owner...',
                style: AppFonts.blackCardSubHeadingText,
              );
            }

            final userName = asyncSnapshot.data?.fullName ?? "Unknown";
            return Text(
              'Owner: $userName',
              style: AppFonts.blackCardSubHeadingText,
            );
          },
        ),
        onTap: () {
          Navigator.push(context, slideTransitionRoute(ListPage(list: list)));
        },
      ),
    );
  }
}

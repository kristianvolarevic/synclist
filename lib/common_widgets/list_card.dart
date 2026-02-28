// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/list/list_page.dart';

// App Imports
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LIST CARD
// --------------------------------------------------------------------------------------------
class ListCard extends StatelessWidget {
  final ShoppingList list;

  const ListCard({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: Key(list.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(color: Colors.redAccent),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            decoration: BoxDecoration(color: AppColors.cardColor),
            child: ListTile(
              title: Text(list.name, style: AppFonts.blackCardHeaderText),
              subtitle: FutureBuilder(
                future: FirebaseController().fetchUserDetails(list.owner),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
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
                Navigator.push(
                  context,
                  slideTransitionRoute(ListPage(list: list)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

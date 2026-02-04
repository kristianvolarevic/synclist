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
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          slideTransitionRoute(ListPage(list: list)),
          /* MaterialPageRoute(
                                  builder: (context) => const Signup(),
                                ), */
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Column(
            children: [
              Text(list.name, style: AppFonts.blackCardHeaderText),
              const SizedBox(height: 10),
              FutureBuilder(
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
            ],
          ),
        ),
      ),
    );
  }
}

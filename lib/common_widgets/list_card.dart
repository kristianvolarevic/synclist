// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/list/list_page.dart';

// App Imports
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/common_widgets/warning_dialog.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LIST CARD
// --------------------------------------------------------------------------------------------
class ListCard extends StatelessWidget {
  final ShoppingList list;

  const ListCard({super.key, required this.list});

  void _handleDelete(BuildContext context) async {
    try {
      await FirebaseController().deleteList(list);

      if (context.mounted) {
        showMessage(context, "List Successfully Deleted");
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, "Unable to delete list: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: Key(list.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  warningMessage:
                      "Are you sure you want to delete this list: ${list.name}?",
                );
              },
            );

            if (confirmed == true && context.mounted) {
              _handleDelete(context);
              return true;
            }

            return false;
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(color: Colors.redAccent),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.onInverseSurface(context),
            ),
            child: ListTile(
              title: Text(list.name, style: AppFonts.cardHeaderText(context)),
              subtitle: FutureBuilder(
                future: FirebaseController().fetchUserDetails(list.owner),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text(
                      'Loading owner...',
                      style: AppFonts.cardSubHeadingText(context),
                    );
                  }

                  final userName = asyncSnapshot.data?.fullName ?? "Unknown";
                  return Text(
                    'Owner: $userName',
                    style: AppFonts.cardSubHeadingText(context),
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

// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synclist/list/list_page.dart';

// App Imports
import 'package:synclist/models/shopping_list.dart';
import 'package:synclist/utils/utils.dart';
import 'package:synclist/common_widgets/warning_dialog.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LIST CARD
// --------------------------------------------------------------------------------------------
class ListCard extends StatelessWidget {
  final ShoppingList list;
  bool get _isOwner => list.owner == FirebaseController().auth.currentUser?.uid;
  String get actionText => _isOwner ? "delete" : "leave";

  const ListCard({super.key, required this.list});

  Future<void> _confirmAndExecuteAction(BuildContext context) async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          warningMessage:
              "Are you sure you want to $actionText this list: ${list.name}?",
        );
      },
    );

    if (confirmed == true && context.mounted) {
      if (_isOwner) {
        _handleDelete(context);
      } else {
        _handleLeave(context);
      }
    }
  }

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

  void _handleLeave(BuildContext context) async {
    try {
      await FirebaseController().leaveListWithId(list.id);
    } catch (e) {
      if (context.mounted) {
        showMessage(context, "Unable to leave list: ${e.toString()}");
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
                      "Are you sure you want to $actionText this list: ${list.name}?",
                );
              },
            );

            if (confirmed == true && context.mounted) {
              _isOwner ? _handleDelete(context) : _handleLeave(context);
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
              trailing: IconButton(
                onPressed: () {
                  _confirmAndExecuteAction(context);
                },
                icon: Icon(
                  _isOwner ? Icons.delete : Icons.exit_to_app,
                  color: _isOwner ? Colors.red : Colors.grey,
                ),
                tooltip: _isOwner ? "Delete List" : "Leave List",
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

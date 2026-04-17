// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:synclist/models/category.dart';
import 'package:synclist/models/shopping_list.dart';
import 'package:synclist/utils/utils.dart';
import 'package:synclist/common_widgets/warning_dialog.dart';

// --------------------------------------------------------------------------------------------
// CLASS: CATEGORY CARD
// --------------------------------------------------------------------------------------------
class CategoryCard extends StatelessWidget {
  final Category category;
  final ShoppingList list;
  final int index;

  const CategoryCard({
    super.key,
    required this.category,
    required this.list,
    required this.index,
  });

  void _handleDelete(BuildContext context) async {
    try {
      await FirebaseController().deleteCategoryForList(category, list);

      if (context.mounted) {
        showMessage(context, "Category Successfully Delted");
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, "Unable to delete category: ${e.toString()}");
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
          key: Key(category.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  warningMessage:
                      "Are you sure you want to delete this category: ${category.name}?",
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
              title: Text(
                category.name,
                style: AppFonts.cardHeaderText(context),
              ),
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/item.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/list/item_dialog.dart';
import 'package:household_groceries/common_widgets/warning_dialog.dart';

// --------------------------------------------------------------------------------------------
// CLASS: ITEM CARD
// --------------------------------------------------------------------------------------------
class ItemCard extends StatelessWidget {
  final Item item;
  final ShoppingList list;
  final Function(bool?) onChecked;
  final VoidCallback fetchItems;

  const ItemCard({
    super.key,
    required this.item,
    required this.list,
    required this.onChecked,
    required this.fetchItems,
  });

  @override
  Widget build(BuildContext context) {
    String amountDisplay = item.isQuantityBased
        ? item.quantity.toString()
        : item.weight.toStringAsFixed(3);

    String unitSuffix = item.isQuantityBased ? "" : " kg";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            final bool? confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  warningMessage:
                      "Are you sure you want to delete this item: ${item.name}",
                );
              },
            );

            if (confirmed == true && context.mounted) {
              handleDeleteItem(context, list, item);
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
            decoration: BoxDecoration(color: AppColors.cardColor),
            child: ListTile(
              title: Text(item.name, style: AppFonts.blackCardHeaderText),
              leading: Text(
                "$amountDisplay$unitSuffix",
                style: AppFonts.blackCardSubHeadingText,
              ),
              trailing: Checkbox(
                value: item.isCollected,
                onChanged: onChecked,
                activeColor: AppColors.contrast,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ItemDialog(
                      item: item,
                      list: list,
                      fetchItems: fetchItems,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

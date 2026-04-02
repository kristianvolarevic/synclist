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

// --------------------------------------------------------------------------------------------
// CLASS: ITEM CARD
// --------------------------------------------------------------------------------------------
class ItemCard extends StatelessWidget {
  // Change to StatelessWidget for better performance
  final Item item;
  final ShoppingList list;

  const ItemCard({super.key, required this.item, required this.list});

  void _handleChecked(BuildContext context, bool? isChecked) async {
    try {
      if (!list.automaticDeletion) {
        await FirebaseController().updateItemCollectedStatus(
          list,
          item,
          isChecked ?? false,
        );
      } else {
        await FirebaseController().deleteItem(list, item);
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      showMessage(context, "Error updating status");
    }
  }

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

        key: Key(item.id),

        child: Container(
          decoration: BoxDecoration(color: AppColors.onInverseSurface(context)),
          child: ListTile(
            title: Text(item.name, style: AppFonts.cardHeaderText(context)),
            leading: Text(
              "$amountDisplay$unitSuffix",
              style: AppFonts.cardSubHeadingText(context),
            ),
            trailing: Checkbox(
              value: item.isCollected,
              onChanged: (val) => _handleChecked(context, val),
              activeColor: AppColors.secondary(context),
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => ItemDialog(item: item, list: list),
            ),
          ),
        ),
      ),
    );
  }
}

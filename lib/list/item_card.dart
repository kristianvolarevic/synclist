// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/item.dart';
import 'package:household_groceries/utils/utils.dart';

// --------------------------------------------------------------------------------------------
// CLASS: ITEM CARD
// --------------------------------------------------------------------------------------------
class ItemCard extends StatelessWidget {
  final Item item;
  final Function(bool?) onChecked;

  const ItemCard({super.key, required this.item, required this.onChecked});

  @override
  Widget build(BuildContext context) {
    String amountDisplay = item.isQuantityBased
        ? item.quantity.toString()
        : item.weight.toStringAsFixed(3);

    String unitSuffix = item.isQuantityBased ? "" : " kg";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white38,
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
      ),
    );
  }
}

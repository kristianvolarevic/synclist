import 'package:flutter/material.dart';
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/firebase_controller.dart';
import 'package:household_groceries/utils/shared_preferences_controller.dart';
import 'package:household_groceries/models/item.dart';

Future<List<Category>?> loadCategories(
  BuildContext context,
  ShoppingList list,
) async {
  try {
    // Fetch categories from Firebase
    List<Category> categories = await FirebaseController()
        .fetchCategoriesForList(list);

    // Sort categories based on SharedPreferences order
    categories = await SharedPreferencesController().fetchCategoriesOrder(
      categories,
      list.id,
    );

    return categories;
  } catch (e) {
    if (context.mounted) {
      showMessage(context, "Error fetching categories: ${e.toString}");
    }
    return null;
  }
}

void showMessage(BuildContext context, String message) {
  final colorScheme = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colorScheme.inverseSurface,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Text(
        message,
        style: TextStyle(
          color:
              colorScheme.onSurface, // Ensures text contrast on the background
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

void handleDeleteItem(
  BuildContext context,
  ShoppingList list,
  Item item,
) async {
  try {
    await FirebaseController().deleteItem(list, item);

    if (context.mounted) {
      showMessage(context, "Item Successfully Delted");
    }
  } catch (e) {
    if (context.mounted) {
      showMessage(context, "Unable to delete item: ${e.toString()}");
    }
  }
}

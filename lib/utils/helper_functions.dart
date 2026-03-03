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
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

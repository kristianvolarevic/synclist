import 'package:flutter/material.dart';
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/firebase_controller.dart';
import 'package:household_groceries/utils/shared_preferences_controller.dart';

Future<List<Category>> loadCategories(ShoppingList list) async {
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
    debugPrint("Error loading categories: $e");
    rethrow;
  }
}

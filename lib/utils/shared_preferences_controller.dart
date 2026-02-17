// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:shared_preferences/shared_preferences.dart';

// App Imports
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/utils/custom_exceptions.dart';

class SharedPreferencesController {
  // --------------------------------------------------------------------------------------------
  // SHARED PREFERENCES METHODS
  // --------------------------------------------------------------------------------------------

  // ---------------------- METHOD: FETCH CATEGORIES ORDER ----------------------
  Future<List<Category>> fetchCategoriesOrder(
    List<Category> categories,
    String listId,
  ) async {
    try {
      // Get instance of shared prefences
      final prefs = await SharedPreferences.getInstance();
      List<Category> sortedCategories = categories;

      List<String>? savedOrder = prefs.getStringList('order_$listId');

      if (savedOrder == null) {
        // Save the current order
        saveCategoriesOrder(sortedCategories, listId);

        return sortedCategories;
      } else {
        sortedCategories.sort((a, b) {
          int indexA = savedOrder.indexOf(a.id);
          int indexB = savedOrder.indexOf(b.id);

          if (indexA == -1) return 1;
          if (indexB == -1) return 1;
          return indexA.compareTo(indexB);
        });

        return sortedCategories;
      }
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  // ---------------------- METHOD: SAVE CATEGORIES ORDER ----------------------
  Future<void> saveCategoriesOrder(
    List<Category> categories,
    String listId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> categoryIDs = categories.map((c) => c.id).toList();

      await prefs.setStringList('order_$listId', categoryIDs);
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }
}

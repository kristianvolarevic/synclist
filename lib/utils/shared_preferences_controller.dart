// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:shared_preferences/shared_preferences.dart';

// App Imports
import 'package:synclist/models/category.dart';
import 'package:synclist/utils/custom_exceptions.dart';

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

  // ---------------------- METHOD: SAVE THEME ----------------------
  Future<void> saveTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', isDark);
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }

  // ---------------------- METHOD: FETCH THEME ----------------------
  Future<bool?> fetchTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool? isDark = prefs.getBool('isDark');

      return isDark;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  // ---------------------- METHOD: SAVE ITEM CATEGORY -----------------------
  Future<void> saveItemCategory(
    String listId,
    String itemName,
    String categoryId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'category_${listId}_${itemName.toLowerCase()}',
        categoryId,
      );
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }

  // ---------------------- METHOD: FETCH ITEM CATEGORY -----------------------
  Future<String?> fetchItemCategory(String listId, String itemName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? categoryId = prefs.getString(
        'category_${listId}_${itemName.toLowerCase()}',
      );

      return categoryId;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  // ---------------------- METHOD: CLEAR SHARED PREFERENCES -------------------
  Future<void> clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.clear();
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToUpdateDatabase);
    }
  }
}

// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:shared_preferences/shared_preferences.dart';

// App Imports
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/utils/customExceptions.dart';

class SharedPreferencesController {
  Future<List<Category>> fetchCategoriesOrder(
    List<Category> categories,
    String listId,
  ) async {
    try {
      // Get instance of shared prefences
      final prefs = await SharedPreferences.getInstance();
      List<Category> sortedCategories = categories;
      print('test');

      List<String>? savedOrder = prefs.getStringList('order_${listId}');

      if (savedOrder == null) {
        // Save the current order
        print("error here");
        throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
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
      print(e);
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }
}

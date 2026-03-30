// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/list/categories/category_card.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/list/categories/add_category_dialog.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LIST PAGE
// --------------------------------------------------------------------------------------------
class Categories extends StatefulWidget {
  final ShoppingList list;

  const Categories({super.key, required this.list});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: 'Categories',
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, size: 20),
      ),
      body: StreamBuilder(
        stream: FirebaseController().categoriesStream(widget.list),
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting ||
              !categorySnapshot.hasData) {
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final categories = categorySnapshot.data!;
          if (categories.isEmpty) {
            const Center(
              child: Text(
                "No categories yet. Click the + button to add one!",
                style: AppFonts.blackSubHeadingText,
                textAlign: TextAlign.center,
              ),
            );
          }

          return Scaffold(
            body: ReorderableListView.builder(
              itemCount: categories.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final Category item = categories.removeAt(oldIndex);
                  categories.insert(newIndex, item);
                });

                // Save the new order to shared preferences
                SharedPreferencesController().saveCategoriesOrder(
                  categories,
                  widget.list.id,
                );
              },
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  key: ValueKey(category.id),
                  category: category,
                  list: widget.list,
                  index: index,
                );
              },
            ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: 75,
              height: 75,
              child: FittedBox(
                child: FloatingActionButton.large(
                  foregroundColor: Colors.white, // Match background color
                  backgroundColor: AppColors.contrast,
                  onPressed: () {
                    // ---------------------------------------------------------------------------------------- ADD NEW LIST DIALOG
                    /* showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddListDialog(fetchLists: _fetchLists);
                      },
                    ); */
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddCategoryDialog(list: widget.list);
                      },
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

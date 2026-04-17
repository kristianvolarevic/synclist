// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:synclist/common_widgets/status_bar_page.dart';
import 'package:synclist/list/categories/category_card.dart';
import 'package:synclist/models/shopping_list.dart';
import 'package:synclist/models/category.dart';
import 'package:synclist/utils/utils.dart';
import 'package:synclist/list/categories/add_category_dialog.dart';

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
  List<Category>? _localCategories;

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
            Center(
              child: Text(
                "No categories yet. Click the + button to add one!",
                style: AppFonts.subHeadingText(context),
                textAlign: TextAlign.center,
              ),
            );
          }

          return FutureBuilder<List<Category>>(
            future: SharedPreferencesController().fetchCategoriesOrder(
              categories,
              widget.list.id,
            ),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData && _localCategories == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (_localCategories == null ||
                  _localCategories!.length != categories.length) {
                _localCategories = asyncSnapshot.data;
              }

              return Scaffold(
                body: ReorderableListView.builder(
                  itemCount: _localCategories!.length,
                  padding: EdgeInsets.only(bottom: 100),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final Category item = _localCategories!.removeAt(
                        oldIndex,
                      );
                      _localCategories!.insert(newIndex, item);
                    });

                    // Save the new order to shared preferences
                    SharedPreferencesController().saveCategoriesOrder(
                      categories,
                      widget.list.id,
                    );
                  },
                  itemBuilder: (context, index) {
                    final category = _localCategories![index];
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
                      backgroundColor: AppColors.secondary(context),
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
          );
        },
      ),
    );
  }
}

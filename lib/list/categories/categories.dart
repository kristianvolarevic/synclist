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
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<Category> unsortedCategories = await FirebaseController()
          .fetchCategoriesForList(widget.list);

      _categories = await SharedPreferencesController().fetchCategoriesOrder(
        unsortedCategories,
        widget.list.id,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching categories: $e")));
    }
  }

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
      body: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _categories.isEmpty
            ? const Center(
                child: Text(
                  "No categories yet. Click the + button to add one!",
                  style: AppFonts.blackSubHeadingText,
                  textAlign: TextAlign.center,
                ),
              )
            : ReorderableListView.builder(
                itemCount: _categories.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final Category item = _categories.removeAt(oldIndex);
                    _categories.insert(newIndex, item);
                  });

                  // Save the new order to shared preferences
                  SharedPreferencesController().saveCategoriesOrder(
                    _categories,
                    widget.list.id,
                  );
                },
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryCard(
                    key: ValueKey(category.id),
                    category: category,
                    index: index,
                  );
                },
              ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    return AddCategoryDialog(
                      list: widget.list,
                      fetchCategories: _fetchCategories,
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/common_widgets/statusBarPage.dart';
import 'package:household_groceries/list/categories/categoryCard.dart';
import 'package:household_groceries/models/shoppingList.dart';
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/list/categories/addCategoryDialog.dart';

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

  _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _categories = await FirebaseController().fetchCategoriesForList(
        widget.list,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
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
            : ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryCard(category: category);
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
                    return AddCategoryDialog(list: widget.list);
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

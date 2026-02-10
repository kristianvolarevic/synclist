// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------

// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/list/listPage.dart';

// App Imports
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/utils/utils.dart';

// --------------------------------------------------------------------------------------------
// CLASS: CATEGORY CARD
// --------------------------------------------------------------------------------------------
class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white38,
      child: ListTile(
        title: Text(category.name, style: AppFonts.blackCardHeaderText),
      ),
    );
  }
}

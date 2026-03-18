import 'package:flutter/material.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';

class AddCategoryDialog extends StatefulWidget {
  final ShoppingList list;

  const AddCategoryDialog({super.key, required this.list});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  String _categoryName = '';

  // ---------------------- METHOD: ADD NEW CATEGORY ----------------------
  void _addNewCategory() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isValid) return; // If form is not valid, exit the method
    _formKey.currentState!.save();

    // ---------------------- Try Adding Category ----------------------
    try {
      await FirebaseController().addNewCategory(_categoryName, widget.list);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(); // Close the dialog

      showMessage(context, "Category added successfully.");
    } catch (e) {
      showMessage(context, "Could not add category: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Category", style: AppFonts.blackHeaderText),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: "Category Name",
            labelStyle: AppFonts.blackSubHeadingText,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a category name';
            }
            return null;
          },
          onSaved: (value) {
            _categoryName = value!;
          },
          style: AppFonts.blackSubHeadingText,
        ),
      ),

      // ---------------------------------------------------------------------------------------- ACTIONS
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: AppFonts.blackSubHeadingText,
            foregroundColor: AppColors.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            textStyle: AppFonts.blackSubHeadingText,
            foregroundColor: AppColors.primary,
          ),
          child: const Text("Create"),
          onPressed: () {
            // Logic to add the item goes here
            _addNewCategory();
          },
        ),
      ],
    );
  }
}

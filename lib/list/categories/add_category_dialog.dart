import 'package:flutter/material.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/firebase_controller.dart';

class AddCategoryDialog extends StatefulWidget {
  final ShoppingList list;
  final VoidCallback fetchCategories;

  const AddCategoryDialog({
    super.key,
    required this.list,
    required this.fetchCategories,
  });

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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Category added successfully!")));

      widget.fetchCategories();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Category"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(hintText: "Enter category name..."),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a category name';
            }
            return null;
          },
          onSaved: (value) {
            _categoryName = value!;
          },
        ),
      ),

      // ---------------------------------------------------------------------------------------- ACTIONS
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
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

import 'package:flutter/material.dart';
import 'package:household_groceries/utils/firebase_controller.dart';

class AddListDialog extends StatefulWidget {
  final VoidCallback fetchLists;

  const AddListDialog({super.key, required this.fetchLists});

  @override
  State<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  final _formKey = GlobalKey<FormState>();
  String _listName = '';

  // ---------------------- METHOD: ADD NEW LIST ----------------------
  void _addNewList() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isValid) return; // If form is not valid, exit the method
    _formKey.currentState!.save();

    // ---------------------- Try Adding List ----------------------
    try {
      await FirebaseController().addNewList(_listName);

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(); // Close the dialog

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("List added successfully!")));

      widget.fetchLists();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create New List"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(hintText: "Enter list name..."),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a list name';
            }
            return null;
          },
          onSaved: (value) {
            _listName = value!;
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
            _addNewList();
          },
        ),
      ],
    );
  }
}

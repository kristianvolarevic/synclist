import 'package:flutter/material.dart';
import 'package:household_groceries/utils/utils.dart';

enum ListAction { create, join }

class AddListDialog extends StatefulWidget {
  const AddListDialog({super.key});

  @override
  State<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  final _formKey = GlobalKey<FormState>();
  ListAction _currentAction = ListAction.create;

  String _listName = '';
  String _joinCode = '';

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

      showMessage(context, "List added successfully!");
    } catch (e) {
      showMessage(context, "Unable to add new list: ${e.toString()}");
    }
  }

  void _joinList() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      final listId = await FirebaseController().getListIdFromCode(_joinCode);

      await FirebaseController().joinListWithId(listId);

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(); // Close the dialog

      showMessage(context, "List joined successfully!");
    } catch (e) {
      if (!mounted) return;
      showMessage(
        context,
        "Unable to join list! Please check the code you entered is correct.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _currentAction == ListAction.create ? "Create New List" : "Join List",
        style: AppFonts.blackHeaderText,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------------- SEGMENTED TAB SELECTOR ----------------------
              SegmentedButton<ListAction>(
                segments: const [
                  ButtonSegment<ListAction>(
                    value: ListAction.create,
                    label: Text('Create'),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment<ListAction>(
                    value: ListAction.join,
                    label: Text('Join'),
                    icon: Icon(Icons.group_add),
                  ),
                ],
                selected: {_currentAction},
                onSelectionChanged: (Set<ListAction> newSelection) {
                  setState(() {
                    _currentAction = newSelection.first;
                  });
                },
                // Styling to match your AppColors
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppColors.contrast,
                  selectedForegroundColor: Colors.white,
                  textStyle: AppFonts.blackSubHeadingText,
                ),
              ),
              const SizedBox(height: 24),

              // ---------------------- DYNAMIC INPUT FIELD ----------------------
              TextFormField(
                // Use a different key for each "tab" so the validation errors clear
                key: ValueKey(_currentAction),
                decoration: InputDecoration(
                  labelText: _currentAction == ListAction.create
                      ? "List Name"
                      : "Enter 6-Digit Code",
                  hintText: _currentAction == ListAction.create
                      ? "e.g. Weekly Shop"
                      : "e.g. H7K2P9",
                ),
                style: AppFonts.blackSubHeadingText,
                // Only capitalize for the join code
                textCapitalization: _currentAction == ListAction.join
                    ? TextCapitalization.characters
                    : TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (_currentAction == ListAction.join && value.length != 6) {
                    return 'Code must be 6 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (_currentAction == ListAction.join) {
                    _joinCode = value!.trim().toUpperCase();
                  } else {
                    _listName = value!;
                  }
                },
              ),
            ],
          ),
        ),
      ),

      // ---------------------------------------------------------------------------------------- ACTIONS
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            textStyle: AppFonts.blackSubHeadingText,
            foregroundColor: AppColors.primary,
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            textStyle: AppFonts.blackSubHeadingText,
            foregroundColor: AppColors.primary,
          ),
          onPressed: _currentAction == ListAction.create
              ? _addNewList
              : _joinList,
          child: Text(_currentAction == ListAction.create ? "Create" : "Join"),
        ),
      ],
    );
  }
}

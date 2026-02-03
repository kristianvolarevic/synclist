// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:household_groceries/common_widgets/statusBarPage.dart';
import 'package:household_groceries/models/shoppingList.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/common_widgets/listCard.dart';

// --------------------------------------------------------------------------------------------
// CLASS: HOME
// --------------------------------------------------------------------------------------------
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// --------------------------------------------------------------------------------------------
// CLASS: _HOME STATE (Page Layout & Logic)
// --------------------------------------------------------------------------------------------
class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  String _listName = '';
  List<ShoppingList> _shoppingLists = [];

  initState() {
    super.initState();
    _fetchLists();
    print('fetching lists...');
  }

  _fetchLists() async {
    try {
      _shoppingLists = await FirebaseController().fetchUserLists();
      setState(() {}); // Update UI after fetching lists
    } catch (e) {
      print('Error fetching lists: $e');
    }
  }

  // ---------------------- METHOD: ADD NEW LIST ----------------------
  _addNewList() async {
    final isVali9d = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isVali9d) return; // If form is not valid, exit the method
    _formKey.currentState!.save();

    // ---------------------- Try Adding List ----------------------
    try {
      await FirebaseController().addNewList(_listName);

      Navigator.of(context).pop(); // Close the dialog

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("List added successfully!")));

      _fetchLists();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: "Home",
      leading: IconButton(
        onPressed: () {
          print("Profile button pressed");
        },
        icon: const Icon(Icons.account_circle, size: 30),
      ),
      body: Scaffold(
        body: ListView.builder(
          itemCount: _shoppingLists.length,
          itemBuilder: (context, index) {
            final list = _shoppingLists[index];
            return ListCard(list: list);
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Create New List"),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Enter list name...",
                          ),
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

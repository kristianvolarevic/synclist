// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/common_widgets/statusBarPage.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';

// Firebase Imports
import 'package:firebase_auth/firebase_auth.dart';

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
  _addNewList() {
    // Logic to add a new list goes here
    try {} catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add new list. $e')));
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ---------------------------------------------------------------------------------------- FAB
                SizedBox(
                  height: 75,
                  width: 75,
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
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                // ---------------------------------------------------------------------------------------- FIELDS
                                children: [
                                  const TextField(
                                    decoration: InputDecoration(
                                      hintText: "Enter list name...",
                                    ),
                                  ),
                                ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

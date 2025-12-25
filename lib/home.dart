// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/common_widgets/statusBarPage.dart';

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
        body: const Center(child: Text("Welcome to the Home Screen!")),
      ),
    );
  }
}

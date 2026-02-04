// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/shoppingList.dart';
import 'package:household_groceries/common_widgets/statusBarPage.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LIST PAGE
// --------------------------------------------------------------------------------------------
class ListPage extends StatefulWidget {
  final ShoppingList list;

  const ListPage({super.key, required this.list});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: widget.list.name,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, size: 20),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (String value) {
          // Handle menu item selection
        },
        itemBuilder: (BuildContext context) {
          return {
            'Categories',
            'Share',
            'Clear Selected',
            'Clear All',
            'Settings',
          }.map((String choice) {
            return PopupMenuItem<String>(value: choice, child: Text(choice));
          }).toList();
        },
      ),
      body: Scaffold(body: Center(child: Text('This is the List Page'))),
    );
  }
}

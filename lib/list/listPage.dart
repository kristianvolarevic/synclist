// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/shoppingList.dart';
import 'package:household_groceries/common_widgets/statusBarPage.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/list/categories/categories.dart';

// --------------------------------------------------------------------------------------------
// ENUM: LIST OPTIONS
// --------------------------------------------------------------------------------------------
enum ListOptions { categories, share, clearSelected, clearAll, settings }

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
      // ---------------------------------------------------------------------------------------- Right side menu for list options
      trailing: PopupMenuButton<ListOptions>(
        onSelected: (ListOptions value) {
          switch (value) {
            case ListOptions.categories:
              // Handle Categories action
              Navigator.push(
                context,
                slideTransitionRoute(Categories(list: widget.list)),
                /* MaterialPageRoute(
                                  builder: (context) => const Signup(),
                                ), */
              );
              break;
            case ListOptions.share:
              // Handle Share action
              break;
            case ListOptions.clearSelected:
              // Handle Clear Selected action
              break;
            case ListOptions.clearAll:
              // Handle Clear All action
              break;
            case ListOptions.settings:
              // Handle Settings action
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<ListOptions>(
              value: ListOptions.categories,
              child: Text('Categories'),
            ),
            const PopupMenuItem<ListOptions>(
              value: ListOptions.share,
              child: Text('Share'),
            ),
            const PopupMenuItem<ListOptions>(
              value: ListOptions.clearSelected,
              child: Text('Clear Selected'),
            ),
            const PopupMenuItem<ListOptions>(
              value: ListOptions.clearAll,
              child: Text('Clear All'),
            ),
            const PopupMenuItem<ListOptions>(
              value: ListOptions.settings,
              child: Text('Settings'),
            ),
          ];
        },
      ),
      body: Scaffold(body: Center(child: Text('This is the List Page'))),
    );
  }
}

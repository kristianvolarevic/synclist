// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/list/categories/categories.dart';
import 'package:household_groceries/list/add_item_dialog.dart';

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
  // ---------------------- METHOD: FETCH ITEMS ----------------------
  void _fetchItems() async {
    debugPrint("Fetching items for list: ${widget.list.name}");
    // TODO: Implement actual list refresh logic here
  }

  // ---------------------- METHOD: HANDLE MENU SELECTION ----------------------
  void _handleMenuSelection(ListOptions value) {
    switch (value) {
      case ListOptions.categories:
        Navigator.push(
          context,
          slideTransitionRoute(Categories(list: widget.list)),
        );
        break;
      case ListOptions.share:
        // TODO: Handle Share
        break;
      case ListOptions.clearSelected:
        // TODO: Handle Clear Selected
        break;
      case ListOptions.clearAll:
        // TODO: Handle Clear All
        break;
      case ListOptions.settings:
        // TODO: Handle Settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: widget.list.name,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, size: 20),
      ),

      // ---------------------- Right side menu for list options ----------------------
      trailing: _buildPopupMenu(),

      body: Scaffold(
        body: const Center(child: Text('This is the List Page')),

        // ---------------------- FLOATING ACTION BUTTON ----------------------
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.large(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.contrast,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddItemDialog(
                  list: widget.list,
                  fetchItems: _fetchItems,
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // ---------------------- WIDGET: POPUP MENU ----------------------
  Widget _buildPopupMenu() {
    return PopupMenuButton<ListOptions>(
      onSelected: _handleMenuSelection,
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
    );
  }
}

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
import 'package:household_groceries/models/category.dart';
import 'package:household_groceries/models/item.dart';
import 'package:household_groceries/list/add_item_dialog.dart';
import 'package:household_groceries/list/item_card.dart';
import 'package:household_groceries/list/share/list_share.dart';

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
  bool _isLoading = true;
  List<Item> _items = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchCategories();
  }

  // ---------------------- METHOD: FETCH ITEMS ----------------------
  void _fetchItems() async {
    try {
      final items = await FirebaseController().fetchItemsForList(widget.list);
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        showMessage(context, "Error fetching items: ${e.toString}");
      }
    }
  }

  void _fetchCategories() async {
    final categories = await loadCategories(context, widget.list);

    if (categories == null) {
      return;
    }

    setState(() {
      _categories = categories;
    });
  }

  void _handleChecked(Item item, bool? isChecked) async {
    try {
      await FirebaseController().updateItemCollectedStatus(
        widget.list,
        item,
        isChecked ?? false,
      );
      setState(() {
        item.isCollected = isChecked ?? false;
      });
    } catch (e) {
      if (mounted) {
        showMessage(context, "Error updating item status: ${e.toString}");
      }
    }
  }

  // ---------------------- METHOD: HANDLE MENU SELECTION ----------------------
  void _handleMenuSelection(ListOptions value) async {
    switch (value) {
      case ListOptions.categories:
        Navigator.push(
          context,
          slideTransitionRoute(Categories(list: widget.list)),
        );
        break;
      case ListOptions.share:
        Navigator.push(
          context,
          slideTransitionRoute(ListShare(list: widget.list)),
        );
        break;
      case ListOptions.clearSelected:
        await FirebaseController().clearSelectedItems(widget.list);
        _fetchItems();
        break;
      case ListOptions.clearAll:
        await FirebaseController().clearAllItems(widget.list);
        _fetchItems();
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _items.isEmpty
            ? const Center(
                child: Text(
                  "No items yet. Click the + button to add one!",
                  style: AppFonts.blackSubHeadingText,
                ),
              )
            : ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, categoryIndex) {
                  final category = _categories[categoryIndex];
                  final categoryItems = _items
                      .where((item) => item.categoryId == category.id)
                      .toList();

                  if (categoryItems.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          category.name,
                          style: AppFonts.blackCardHeaderText,
                        ),
                      ),
                      ...categoryItems.map((item) {
                        return ItemCard(
                          item: item,
                          list: widget.list,
                          onChecked: (isChecked) =>
                              _handleChecked(item, isChecked),
                          fetchItems: _fetchItems,
                        );
                      }),
                    ],
                  );
                },
              ),

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

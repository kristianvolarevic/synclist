// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:firebase_core/firebase_core.dart';
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
enum ListOptions { categories, share, clearSelected, clearAll, settings, leave }

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
  void initState() {
    super.initState();
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
          slideTransitionRoute(ListShare(listId: widget.list.id)),
        );
        break;
      case ListOptions.clearSelected:
        await FirebaseController().clearSelectedItems(widget.list);
        break;
      case ListOptions.clearAll:
        await FirebaseController().clearAllItems(widget.list);
        break;
      case ListOptions.settings:
        // TODO: Handle Settings
        break;
      case ListOptions.leave:
        Navigator.pop(context);
        await FirebaseController().leaveListWithId(widget.list.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseController().auth.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseController().streamSingleList(widget.list.id),
      builder: (context, listSnapshot) {
        if (listSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (!listSnapshot.hasData) return const SizedBox.shrink();

        final liveList = listSnapshot.data!;

        // KICK LOGIC
        final isOwner = liveList.owner == currentUserId;
        final isJoined = liveList.joinedUsers.contains(currentUserId);

        if (!isOwner && !isJoined) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            showMessage(context, "You no longer have access to this list.");
          });
          const SizedBox.shrink();
        }

        // List Page
        return StatusBarPage(
          title: widget.list.name,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),

          // ---------------------- Right side menu for list options ----------------------
          trailing: _buildPopupMenu(),

          body: Scaffold(
            body: StreamBuilder(
              stream: FirebaseController().categoriesStream(widget.list),
              builder: (context, categorySnapshot) {
                if (!categorySnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final categories = categorySnapshot.data!;

                return StreamBuilder<List<Item>>(
                  stream: FirebaseController().itemsStream(widget.list),
                  builder: (context, snapshot) {
                    // 1. Handle Loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    // 2. Handle Errors
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    // 3. Check if user has access
                    final currentUser =
                        FirebaseController().auth.currentUser!.uid;
                    if (!widget.list.joinedUsers.contains(currentUser) &&
                        widget.list.owner != currentUser) {
                      Navigator.pop(context);
                    }

                    // 4. Handle Data
                    final allItems = snapshot.data ?? [];

                    if (allItems.isEmpty) {
                      return const Center(
                        child: Text(
                          "No items yet. Click the + button!",
                          style: AppFonts.blackSubHeadingText,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = categories[categoryIndex];
                        final categoryItems = allItems
                            .where((item) => item.categoryId == category.id)
                            .toList();

                        if (categoryItems.isEmpty)
                          return const SizedBox.shrink();

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
                              );
                            }),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            // ---------------------- FLOATING ACTION BUTTON ----------------------
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.large(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.contrast,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddItemDialog(list: widget.list);
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  // ---------------------- WIDGET: POPUP MENU ----------------------
  Widget _buildPopupMenu() {
    return PopupMenuButton<ListOptions>(
      onSelected: _handleMenuSelection,
      itemBuilder: (BuildContext context) {
        final isOwner =
            FirebaseController().auth.currentUser!.uid == widget.list.owner;

        return [
          const PopupMenuItem<ListOptions>(
            value: ListOptions.categories,
            child: Text('Categories'),
          ),

          if (isOwner)
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
          if (isOwner)
            const PopupMenuItem<ListOptions>(
              value: ListOptions.settings,
              child: Text('Settings'),
            ),
          if (!isOwner)
            const PopupMenuItem<ListOptions>(
              value: ListOptions.leave,
              child: Text('Leave'),
            ),
        ];
      },
    );
  }
}

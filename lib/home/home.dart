// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/home/add_list_dialog.dart';
import 'package:household_groceries/models/shopping_list.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/common_widgets/list_card.dart';

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
  bool _isLoading = true;
  List<ShoppingList> _shoppingLists = [];

  @override
  initState() {
    super.initState();
    _fetchLists();
  }

  void _fetchLists() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _shoppingLists = await FirebaseController().fetchUserLists();
      setState(() {
        _isLoading = false;
      }); // Update UI after fetching lists
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : _shoppingLists.isEmpty
            ? const Center(
                child: Text(
                  "No lists yet. Click the + button to add one!",
                  style: AppFonts.blackSubHeadingText,
                ),
              )
            : ListView.builder(
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
                    return AddListDialog(fetchLists: _fetchLists);
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

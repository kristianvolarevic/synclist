// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/home/add_list_dialog.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/common_widgets/list_card.dart';
import 'package:household_groceries/profile.dart';

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
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: "Home",
      leading: IconButton(
        onPressed: () {
          Navigator.push(context, slideTransitionRoute(Profile()));
        },
        icon: const Icon(Icons.account_circle, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          body: StreamBuilder(
            stream: FirebaseController().userListsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
        
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
        
              final allLists = snapshot.data ?? [];
        
              if (allLists.isEmpty) {
                return Center(
                  child: Text(
                    "No lists yet. Click the + button to create or join one!",
                    style: AppFonts.subHeadingText(context), textAlign: TextAlign.center,
                  ),
                );
              }
        
              return ListView.builder(
                itemCount: allLists.length,
                padding: EdgeInsets.only(bottom: 100),
                itemBuilder: (context, index) {
                  return ListCard(
                    list: allLists[index],
                  ); // Now receives a ShoppingList object
                },
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: 75,
            height: 75,
            child: FittedBox(
              child: FloatingActionButton.large(
                foregroundColor: Colors.white, // Match background color
                backgroundColor: AppColors.secondary(context),
                onPressed: () {
                  // ---------------------------------------------------------------------------------------- ADD NEW LIST DIALOG
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddListDialog();
                    },
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

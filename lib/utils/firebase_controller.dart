// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'dart:async';

// App Imports
import 'package:household_groceries/home/home.dart';
import 'package:household_groceries/models/user.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/models/category.dart';

// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --------------------------------------------------------------------------------------------
// CLASS: FIREBASE CONTROLLER
// --------------------------------------------------------------------------------------------
class FirebaseController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // --------------------------------------------------------------------------------------------
  // AUTHENTICATION METHODS
  // --------------------------------------------------------------------------------------------

  // ---------------------- METHOD: LOGIN ----------------------
  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw CustomExceptions(ExceptionType.userNotFound);
      }

      if (!context.mounted) {
        throw CustomExceptions(ExceptionType.contextNotFound);
      }

      if (!isUserVerified(user)) {
        user.sendEmailVerification();
        showCustomDialog(
          "Not Verified",
          "You have not verified your email address for $email. Please check your inbox and spam folder.",
          context,
        );

        startTimer(context);
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        slideTransitionRoute(const Home()),
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      throw CustomExceptions(ExceptionType.wrongEmailOrPassword);
    }
  }

  // ---------------------- METHOD: SIGN UP ----------------------
  Future<void> signUp(
    String email,
    String password,
    String fullName,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        throw CustomExceptions(ExceptionType.userNotFound);
      }

      await user.sendEmailVerification();

      if (!context.mounted) {
        throw CustomExceptions(ExceptionType.contextNotFound);
      }
      showCustomDialog(
        "Email Verification Sent",
        "A verification link has been sent to $email. Please check your inbox and spam folder.",
        context,
      );

      user.updateDisplayName(fullName);

      db.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'email': email,
        'lists': [],
      });

      // Check every 3 seconds if email is verified
      startTimer(context);
    } catch (e) {
      throw CustomExceptions(ExceptionType.emailAlreadyInUse);
    }
  }

  // ---------------------- METHOD: IS USER VERIFIED ----------------------
  bool isUserVerified(User? user) {
    if (user == null) {
      return false;
    }

    // Check that the user still exists
    user.reload();
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      auth.signOut();
      return false;
    }

    // Check if email is verified
    if (!user.emailVerified) {
      return false;
    }

    return true;
  }

  // ---------------------- METHOD: Fetch User Details ----------------------
  Future<UserDetails?> fetchUserDetails(String userID) async {
    final userDoc = await db.collection('users').doc(userID).get();

    if (!userDoc.exists) {
      throw CustomExceptions(ExceptionType.userNotFound);
    }

    final data = userDoc.data()!;
    UserDetails user = UserDetails.fromMap(userID, data);

    return user;
  }

  // --------------------------------------------------------------------------------------------
  // LIST METHODS
  // --------------------------------------------------------------------------------------------

  // ---------------------- METHOD: Add New List ----------------------
  Future<void> addNewList(String listName) async {
    try {
      // Create the list
      ShoppingList newList = ShoppingList(
        id: '',
        name: listName,
        owner: auth.currentUser!.uid,
      );

      // Add the list to Firestore
      final docRef = await db.collection('lists').add(newList.toMap());

      // Store the list in the users collection under the current user
      await db.collection('users').doc(auth.currentUser!.uid).update({
        'lists': FieldValue.arrayUnion([docRef.id]),
      });
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }

  // ---------------------- METHOD: Fetch Users Lists ----------------------
  Future<List<ShoppingList>> fetchUserLists() async {
    try {
      final userDoc = await db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw CustomExceptions(ExceptionType.userNotFound);
      }

      List<dynamic> listIds = userDoc.data()?['lists'] ?? [];
      List<ShoppingList> userLists = [];

      for (String listId in listIds) {
        final listDoc = await db.collection('lists').doc(listId).get();
        if (listDoc.exists) {
          userLists.add(ShoppingList.fromMap(listDoc.id, listDoc.data()!));
        }
      }

      return userLists;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  // --------------------------------------------------------------------------------------------
  // CATEGORY METHODS
  // --------------------------------------------------------------------------------------------
  // ---------------------- METHOD: Add New Category ----------------------
  Future<void> addNewCategory(String categoryName, ShoppingList list) async {
    try {
      // Create the category
      Category newCategory = Category(id: '', name: categoryName);

      // Add the category to Firestore
      final docRef = await db
          .collection('lists')
          .doc(list.id)
          .collection('categories')
          .add(newCategory.toMap());

      // Store the category in the list document under the current list
      await db.collection('lists').doc(list.id).update({
        'categoryIds': FieldValue.arrayUnion([docRef.id]),
      });
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }

  // ---------------------- METHOD: Fetch Categories For List ----------------------
  Future<List<Category>> fetchCategoriesForList(ShoppingList list) async {
    try {
      final categoriesSnapshot = await db
          .collection('lists')
          .doc(list.id)
          .collection('categories')
          .get();

      List<Category> categories = [];
      for (final doc in categoriesSnapshot.docs) {
        categories.add(Category.fromMap(doc.id, doc.data()));
      }

      return categories;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  // --------------------------------------------------------------------------------------------
  // HELPER METHODS
  // --------------------------------------------------------------------------------------------

  // ---------------------- METHOD: START TIMER ----------------------
  void startTimer(BuildContext context) {
    // Check every 3 seconds if email is verified
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw CustomExceptions(ExceptionType.userNotFound);
      }

      if (currentUser.emailVerified != false) {
        timer.cancel();

        // Navigate to Home and remove all previous routes
        if (!context.mounted) {
          throw CustomExceptions(ExceptionType.contextNotFound);
        }

        Navigator.pushAndRemoveUntil(
          context,
          slideTransitionRoute(const Home()),
          (route) => false, // Remove all previous routes
        );
      }
    });
  }

  // ---------------------- METHOD: SHOW CUSTOM DIALOG ----------------------
  void showCustomDialog(String title, String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppFonts.blackHeaderText),
        content: Text(text, style: AppFonts.blackSubHeadingText),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text("Close", style: AppFonts.orangeLinkText),
          ),
        ],
      ),
    );
  }
}

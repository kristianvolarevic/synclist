// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// App Imports
import 'package:synclist/home/home.dart';
import 'package:synclist/models/item.dart';
import 'package:synclist/models/user.dart';
import 'package:synclist/utils/utils.dart';
import 'package:synclist/models/shopping_list.dart';
import 'package:synclist/models/category.dart';

// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --------------------------------------------------------------------------------------------
// CLASS: FIREBASE CONTROLLER
// --------------------------------------------------------------------------------------------
class FirebaseController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final userCollection = 'users';
  final listCollection = 'lists';
  final categoriesCollection = 'categories';
  final itemsCollection = 'items';
  final shareCollection = 'share_codes';

  // ----------------------------------------------------------- AUTHENTICATION METHODS -------------------------------------------------------------------------------
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

      db.collection(userCollection).doc(user.uid).set({
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
    bool isBigpond = user.email?.contains('bigpond') ?? false;

    if (!user.emailVerified && !isBigpond) {
      return false;
    }

    return true;
  }

  // ---------------------- METHOD: Fetch User Details ----------------------
  Future<UserDetails?> fetchUserDetails(String userID) async {
    final userDoc = await db.collection(userCollection).doc(userID).get();

    if (!userDoc.exists) {
      throw CustomExceptions(ExceptionType.userNotFound);
    }

    final data = userDoc.data()!;
    UserDetails user = UserDetails.fromMap(userID, data);

    return user;
  }

  Stream<List<ShoppingList>> userListsStream() {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw CustomExceptions(ExceptionType.userNotFound);
    }

    return db.collection(userCollection).doc(userId).snapshots().asyncMap((
      userDoc,
    ) async {
      if (!userDoc.exists) return [];

      final listIds = List<String>.from(userDoc.data()?['lists'] ?? []);
      if (listIds.isEmpty) return [];

      List<ShoppingList> lists = [];
      for (String id in listIds) {
        final doc = await db.collection(listCollection).doc(id).get();
        if (doc.exists) {
          lists.add(ShoppingList.fromMap(doc.id, doc.data()!));
        }
      }
      return lists;
    });

    /* return db.collection(userCollection).doc(userId).snapshots().map((doc) {
      if (!doc.exists) {
        throw CustomExceptions(ExceptionType.userNotFound);
      }
      return UserDetails.fromMap(doc.id, doc.data()!);
    }); */
  }

  Future<void> updateUser(UserDetails user) async {
    try {
      await db.collection(userCollection).doc(user.id).update(user.toMap());
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToUpdateDatabase);
    }
  }

  Stream<UserDetails> userDetailsStream(String userID) {
    return db.collection(userCollection).doc(userID).snapshots().map((doc) {
      if (!doc.exists) {
        throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
      }
      return UserDetails.fromMap(doc.id, doc.data()!);
    });
  }

  // ----------------------------------------------------------- LIST METHODS -------------------------------------------------------------------------------

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
      final docRef = await db.collection(listCollection).add(newList.toMap());

      // Store the list in the users collection under the current user
      await db.collection(userCollection).doc(auth.currentUser!.uid).update({
        'lists': FieldValue.arrayUnion([docRef.id]),
      });
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }

  Stream<ShoppingList> streamSingleList(String listId) {
    return db.collection(listCollection).doc(listId).snapshots().map((doc) {
      if (!doc.exists) {
        throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
      }
      return ShoppingList.fromMap(doc.id, doc.data()!);
    });
  }

  // ---------------------- METHOD: Fetch Users Lists ----------------------
  Future<List<ShoppingList>> fetchUserLists() async {
    try {
      final userDoc = await db
          .collection(userCollection)
          .doc(auth.currentUser!.uid)
          .get();

      if (!userDoc.exists) {
        throw CustomExceptions(ExceptionType.userNotFound);
      }

      List<dynamic> listIds = userDoc.data()?['lists'] ?? [];
      List<ShoppingList> userLists = [];

      for (String listId in listIds) {
        final listDoc = await db.collection(listCollection).doc(listId).get();
        if (listDoc.exists) {
          userLists.add(ShoppingList.fromMap(listDoc.id, listDoc.data()!));
        }
      }

      return userLists;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  // ---------------------- METHOD: Delete List ----------------------
  Future<void> deleteList(ShoppingList list) async {
    try {
      await db.collection(listCollection).doc(list.id).delete();

      // Also remove from users list
      await db.collection(userCollection).doc(auth.currentUser!.uid).update({
        'lists': FieldValue.arrayRemove([list.id]),
      });
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToDeleteFromDatabase);
    }
  }

  Future<ShoppingList> fetchListWithId(String listId) async {
    try {
      final docRef = await db.collection(listCollection).doc(listId).get();

      if (!docRef.exists) {
        throw Error();
      }

      final data = docRef.data()!;
      ShoppingList list = ShoppingList.fromMap(listId, data);

      return list;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  Future<void> joinListWithId(String listId) async {
    try {
      final list = await fetchListWithId(listId);
      final userId = auth.currentUser?.uid;

      if (userId == null) {
        throw Error();
      }

      // Add user to the list
      list.joinedUsers.add(userId);
      await db.collection(listCollection).doc(list.id).update(list.toMap());

      // Add list to the user
      await db.collection(userCollection).doc(auth.currentUser!.uid).update({
        'lists': FieldValue.arrayUnion([list.id]),
      });
    } catch (e) {
      CustomExceptions(ExceptionType.failedToUpdateDatabase);
    }
  }

  Future<void> leaveListWithId(String listId) async {
    try {
      final list = await fetchListWithId(listId);
      final userId = auth.currentUser?.uid;

      if (userId == null) {
        throw Error();
      }

      // Remove user from the list
      list.joinedUsers.remove(userId);
      await db.collection(listCollection).doc(list.id).update(list.toMap());

      // Remove list from the user
      await db.collection(userCollection).doc(auth.currentUser!.uid).update({
        'lists': FieldValue.arrayRemove([list.id]),
      });
    } catch (e) {
      CustomExceptions(ExceptionType.failedToUpdateDatabase);
    }
  }

  Future<void> updateList(ShoppingList list) async {
    try {
      await db.collection(listCollection).doc(list.id).update(list.toMap());
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToUpdateDatabase);
    }
  }

  // ---------------------- METHOD: Remove User From List ----------------------
  Future<void> removeUserFromList(String listId, String userId) async {
    try {
      await db.collection(listCollection).doc(listId).update({
        'joinedUsers': FieldValue.arrayRemove([userId]),
      });

      await db.collection(userCollection).doc(userId).update({
        'lists': FieldValue.arrayRemove([listId]),
      });
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToDeleteFromDatabase);
    }
  }

  // ----------------------------------------------------------- CATEGORY METHODS -------------------------------------------------------------------------------
  // ---------------------- METHOD: Add New Category ----------------------

  // ---------------------- METHOD: Add New Category ----------------------
  Future<void> addNewCategory(String categoryName, ShoppingList list) async {
    try {
      // Create the category
      Category newCategory = Category(id: '', name: categoryName);

      // Add the category to Firestore
      await db
          .collection(listCollection)
          .doc(list.id)
          .collection(categoriesCollection)
          .add(newCategory.toMap());
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }

  // ---------------------- METHOD: Delete Category For List ----------------------
  Future<void> deleteCategoryForList(
    Category category,
    ShoppingList list,
  ) async {
    try {
      await db
          .collection(listCollection)
          .doc(list.id)
          .collection(categoriesCollection)
          .doc(category.id)
          .delete();
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToDeleteFromDatabase);
    }
  }

  // ---------------------- METHOD: Fetch Categories For List ----------------------
  Future<List<Category>> fetchCategoriesForList(ShoppingList list) async {
    try {
      final categoriesSnapshot = await db
          .collection(listCollection)
          .doc(list.id)
          .collection(categoriesCollection)
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

  // ---------------------- METHOD: Categories Stream ----------------------
  Stream<List<Category>> categoriesStream(ShoppingList list) {
    return db
        .collection(listCollection)
        .doc(list.id)
        .collection(categoriesCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Category.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // ----------------------------------------------------------- ITEM METHODS -------------------------------------------------------------------------------

  // ---------------------- METHOD: Add New Item ----------------------
  Future<void> addNewItem(Item item, ShoppingList list) async {
    try {
      // Add the item to Firestore
      await db
          .collection(listCollection)
          .doc(list.id)
          .collection(itemsCollection)
          .add(item.toMap());
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToAddToDatabase);
    }
  }

  // ---------------------- METHOD: Fetch Items For List ----------------------
  Future<List<Item>> fetchItemsForList(ShoppingList list) async {
    try {
      final itemsSnapshot = await db
          .collection(listCollection)
          .doc(list.id)
          .collection(itemsCollection)
          .get();

      List<Item> items = [];
      for (final doc in itemsSnapshot.docs) {
        items.add(Item.fromMap(doc.id, doc.data()));
      }

      return items;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }

  // ---------------------- METHOD: Update Item Collected Status ----------------------
  Future<void> updateItemCollectedStatus(
    ShoppingList list,
    Item item,
    bool isCollected,
  ) async {
    try {
      await db
          .collection(listCollection)
          .doc(list.id)
          .collection(itemsCollection)
          .doc(item.id)
          .update({'isCollected': isCollected});
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToUpdateDatabase);
    }
  }

  // ---------------------- METHOD: Delete Item ----------------------
  Future<void> deleteItem(ShoppingList list, Item item) async {
    try {
      await db
          .collection(listCollection)
          .doc(list.id)
          .collection(itemsCollection)
          .doc(item.id)
          .delete();
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToDeleteFromDatabase);
    }
  }

  // ---------------------- METHOD: Update Item ----------------------
  Future<void> updateItem(Item item, ShoppingList list) async {
    try {
      await db
          .collection(listCollection)
          .doc(list.id)
          .collection(itemsCollection)
          .doc(item.id)
          .update(item.toMap());
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToUpdateDatabase);
    }
  }

  // ---------------------- METHOD: Clear Selected Items ----------------------
  Future<void> clearSelectedItems(ShoppingList list) async {
    try {
      final itemsSnapshot = await db
          .collection(listCollection)
          .doc(list.id)
          .collection(itemsCollection)
          .where('isCollected', isEqualTo: true)
          .get();

      final WriteBatch batch = db.batch();

      for (final doc in itemsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToDeleteFromDatabase);
    }
  }

  // ---------------------- METHOD: Clear All Items ----------------------
  Future<void> clearAllItems(ShoppingList list) async {
    try {
      final itemsSnapshot = await db
          .collection(listCollection)
          .doc(list.id)
          .collection(itemsCollection)
          .get();

      final WriteBatch batch = db.batch();

      for (final doc in itemsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToDeleteFromDatabase);
    }
  }

  Stream<List<Item>> itemsStream(ShoppingList list) {
    return db
        .collection(listCollection)
        .doc(list.id)
        .collection(itemsCollection)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Item.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // ----------------------------------------------------------- HELPER METHODS -------------------------------------------------------------------------------

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
        title: Text(title, style: AppFonts.headerText(context)),
        content: Text(text, style: AppFonts.subHeadingText(context)),
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

  // ---------------------- METHOD: GENERATE UNIQUE CODE ----------------------
  Future<String> generateUniqueCode(ShoppingList list) async {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
    final random = Random();
    bool isUnique = false;
    String code = '';

    // Generate the code and check if it exists
    while (!isUnique) {
      code = List.generate(
        6,
        (index) => chars[random.nextInt(chars.length)],
      ).join();

      final doc = await db.collection(shareCollection).doc(code).get();
      if (!doc.exists) {
        isUnique = true;
      }
    }

    // Save the code in firebase
    await db.collection(shareCollection).doc(code).set({
      'targetListId': list.id,
    });

    // Update the shopping list to contain the code
    await db.collection(listCollection).doc(list.id).update({
      'shareCode': code,
      'isShared': true,
    });

    list.code = code;
    list.isShared = true;

    return code;
  }

  Future<void> deleteUniqueCode(ShoppingList list) async {
    try {
      // Delete code
      await db.collection(shareCollection).doc(list.code).delete();

      // Remove share information from list
      await db.collection(listCollection).doc(list.id).update({
        'shareCode': '',
        'isShared': false,
        'joinedUsers': [],
      });

      // Remove list from all users
      for (String userId in list.joinedUsers) {
        await db.collection(userCollection).doc(userId).update({
          'lists': FieldValue.arrayRemove([list.id]),
        });
      }
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToDeleteFromDatabase);
    }
  }

  Future<String> getListIdFromCode(String code) async {
    try {
      String cleanCode = code.trim().toUpperCase();

      DocumentSnapshot doc = await db
          .collection(shareCollection)
          .doc(cleanCode)
          .get();

      if (!doc.exists) {
        throw Error();
      }

      final data = doc.data() as Map<String, dynamic>;
      return data['targetListId'] as String;
    } catch (e) {
      throw CustomExceptions(ExceptionType.failedToFetchFromDatabase);
    }
  }
}

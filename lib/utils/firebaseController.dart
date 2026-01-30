// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'dart:async';

// App Imports
import 'package:household_groceries/home.dart';
import 'package:household_groceries/utils/utils.dart';

// Firebase Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

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

      // Check every 3 seconds if email is verified
      startTimer(context);
    } catch (e) {
      throw CustomExceptions(ExceptionType.emailAlreadyInUse);
    }
  }

  bool isUserVerified(User? user) {
    if (user == null) {
      return false;
    }

    if (!user.emailVerified) {
      return false;
    }

    return true;
  }

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

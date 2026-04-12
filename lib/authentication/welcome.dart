// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';
import 'login.dart';
import 'signup.dart';

// --------------------------------------------------------------------------------------------
// CLASS: WELCOME
// --------------------------------------------------------------------------------------------
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  // ---------------------- METHOD: BUILD ----------------------
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // For iOS
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Container(
                width: double
                    .infinity, // Makes the container take the maxiumum width possible
                height: MediaQuery.of(
                  context,
                ).size.height, // Takes the height of the device
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ), // Padding for the container, so children do not touch the
                child: Column(
                  // Main column holding all the widgets
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Equally space out children
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center horizontally
                  children: <Widget>[
                    Column(
                      // Column for the text widgets
                      // ---------------------------------------------------------------------------------------- TITLE
                      children: <Widget>[
                        Text("Welcome", style: AppFonts.headerText(context).copyWith(color: Colors.white)),
                        const SizedBox(height: 20),

                        // ---------------------------------------------------------------------------------------- SUBTITLE
                        Text(
                          "Collaborate with your household members and manage your groceries efficiently!",
                          textAlign: TextAlign.center,
                          style: AppFonts.subHeadingText(context).copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                        // ---------------------------------------------------------------------------------------- LOGO IMAGE
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/logo.png",
                          ), // Flutter Dash image
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        // ---------------------------------------------------------------------------------------- LOGIN BUTTON
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                              context,
                              slideTransitionRoute(const Login()),
                            );
                          },
                          color: AppColors.secondary(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Login",
                            style: AppFonts.whiteTextField,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ---------------------------------------------------------------------------------------- SIGNUP BUTTON
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                              context,
                              slideTransitionRoute(const Signup()),
                            );
                          },
                          color: AppColors.grey800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Sign up",
                            style: AppFonts.whiteTextField,
                          ),
                        ),
                        // ---------------------------------------------------------------------------------------- END OF COLUMN
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

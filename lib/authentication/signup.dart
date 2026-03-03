// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:household_groceries/common_widgets/status_bar_page.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';

// --------------------------------------------------------------------------------------------
// CLASS: SIGNUP
// --------------------------------------------------------------------------------------------
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

// --------------------------------------------------------------------------------------------
// CLASS: _SIGNUPSTATE (Page Layout & Logic)
// --------------------------------------------------------------------------------------------
class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------------- METHOD: TRY SUBMIT ----------------------
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate(); // Validate form fields
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isValid) return; // If form is not valid, exit the method

    _formKey.currentState!.save();

    // ---------------------- Try Sign Up ----------------------
    try {
      FirebaseController firebaseController = FirebaseController();

      await firebaseController.signUp(_email, _password, _fullName, context);
    }
    // ---------------------- Error Handling ----------------------
    catch (e) {
      if (!mounted) {
        return;
      }

      showMessage(context, "Error signing up: ${e.toString()}");
    }
  }

  // ---------------------- METHOD: BUILD INPUT FIELD ----------------------
  Widget buildInputField({
    required String label,
    required TextStyle labelStyle,
    required IconData icon,
    required ValueKey key,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextFormField(
          key: key,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: labelStyle,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: Icon(icon),
          ),
          keyboardType: keyboardType,
          obscureText: isPassword,
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }

  // ---------------------- METHOD: BUILD ----------------------
  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: "Sign Up",
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios, size: 20),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // ---------------------------------------------------------------------------------------- HEADER
                      const Text(
                        "Create your account",
                        style: AppFonts.blackHeaderText,
                      ),

                      const SizedBox(height: 10),

                      // ---------------------------------------------------------------------------------------- SUBHEADER
                      Text(
                        "Sign up now to get started!",
                        style: AppFonts.blackSubHeadingText,
                      ),

                      const SizedBox(height: 40),

                      // ---------------------------------------------------------------------------------------- FULL NAME
                      buildInputField(
                        key: const ValueKey('fullname'),
                        label: 'Full Name',
                        labelStyle: AppFonts.blackTextFieldUnfocussed,
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _fullName = value!;
                        },
                      ),

                      // ---------------------------------------------------------------------------------------- EMAIL
                      buildInputField(
                        key: const ValueKey('email'),
                        label: 'Email Address',
                        labelStyle: AppFonts.blackTextFieldUnfocussed,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                      ),

                      // ---------------------------------------------------------------------------------------- PASSWORD
                      buildInputField(
                        key: const ValueKey('password'),
                        label: 'Password',
                        labelStyle: AppFonts.blackTextFieldUnfocussed,
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          _password =
                              value ??
                              ''; // Temporarily store password for confirmation check
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),

                      // ---------------------------------------------------------------------------------------- CONFIRM PASSWORD
                      buildInputField(
                        key: const ValueKey('confirm_password'),
                        label: 'Confirm Password',
                        labelStyle: AppFonts.blackTextFieldUnfocussed,
                        icon: Icons.lock_reset,
                        isPassword: true,
                        validator: (value) {
                          if (value != _password) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      // ---------------------------------------------------------------------------------------- SIGNUP BUTTON
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: _trySubmit,
                        color: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: AppFonts.whiteTextField,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ---------------------------------------------------------------------------------------- LOGIN LINK
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
                            style: AppFonts.blackSubHeadingText,
                          ),
                          TextButton(
                            onPressed: () {
                              // Go back to the previous screen (which is likely the Welcome or Login page)
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Login",
                              style: AppFonts.orangeLinkText,
                            ),
                          ),
                        ],
                      ),
                      // ---------------------------------------------------------------------------------------- END OF COLUMN
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';

// Firebase Imports
import 'package:firebase_auth/firebase_auth.dart';

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

  // ---------------------- METHOD: TRY SUBMIT ----------------------
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate(); // Validate form fields
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isValid) return; // If form is not valid, exit the method

    _formKey.currentState!.save();

    // ---------------------- Try Sign Up ----------------------
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);

      final User? user = userCredential.user; // Get the created user

      if (user != null) {
        // If user creation is successful set their name
        await user.updateDisplayName(_fullName);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up successful! Welcome, ${user.email}')),
        );
      }
    }
    // ---------------------- Error Handling ----------------------
    catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign up failed: $e')));
      return;
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

  @override
  Widget build(BuildContext context) {
    // Status bar style for the Sign Up page (dark app bar, white icons)
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // For iOS
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
          titleTextStyle: AppFonts.whiteTitleText,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
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
                        const Text(
                          "Create your account",
                          style: AppFonts.blackHeaderText,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Sign up now to get started!",
                          style: AppFonts.blackSubHeadingText,
                        ),
                        const SizedBox(height: 40),

                        // Full Name
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

                        // Email
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

                        // Password
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

                        // Confirm Password
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

                        // Sign Up Button
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

                        // Already have an account link
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
                      ],
                    ),
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

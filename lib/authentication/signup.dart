// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:synclist/common_widgets/status_bar_page.dart';

// App Imports
import 'package:synclist/utils/utils.dart';

// SVG
import 'package:flutter_svg/flutter_svg.dart';

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

  // Password visibilities
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

  // ---------------------- METHOD: GOOGLE SIGN IN ----------------------
  void _handleGoogleSignIn() async {
    try {
      await FirebaseController().signInWithGoogle(context);
    } catch (e) {
      if (!mounted) return;
      showMessage(context, "Google login failed: ${e.toString()}");
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
    bool obscureTextValue = false,
    bool showToggle = false,
    VoidCallback? onTogglePressed,
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
            suffixIcon: showToggle
                ? IconButton(
                    onPressed: onTogglePressed,
                    icon: Icon(
                      obscureTextValue
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  )
                : null,
          ),
          keyboardType: keyboardType,
          obscureText: isPassword ? obscureTextValue : false,
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
                      Text(
                        "Create your account",
                        style: AppFonts.headerText(context),
                      ),

                      const SizedBox(height: 10),

                      // ---------------------------------------------------------------------------------------- SUBHEADER
                      Text(
                        "Sign up now to get started!",
                        style: AppFonts.subHeadingText(context),
                      ),

                      const SizedBox(height: 40),

                      // ---------------------------------------------------------------------------------------- FULL NAME
                      buildInputField(
                        key: const ValueKey('fullname'),
                        label: 'Full Name',
                        labelStyle: AppFonts.textUnfocused(context),
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
                        labelStyle: AppFonts.textUnfocused(context),
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
                        labelStyle: AppFonts.textUnfocused(context),
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureTextValue: _obscurePassword,
                        showToggle: true,
                        onTogglePressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
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
                        labelStyle: AppFonts.textUnfocused(context),
                        icon: Icons.lock_reset,
                        isPassword: true,
                        obscureTextValue: _obscureConfirmPassword,
                        showToggle: true,
                        onTogglePressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
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

                      // ---------------------------------------------------------------------------------------- NEW: OR DIVIDER
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "OR",
                                style: AppFonts.textUnfocused(context),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ---------------------------------------------------------------------------------------- NEW: GOOGLE SIGN IN BUTTON
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        onPressed: _handleGoogleSignIn,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/google_logo.svg',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Continue with Google",
                              style: AppFonts.subHeadingText(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ---------------------------------------------------------------------------------------- LOGIN LINK
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
                            style: AppFonts.subHeadingText(context),
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

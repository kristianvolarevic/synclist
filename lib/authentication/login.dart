// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:synclist/utils/utils.dart';
import 'signup.dart';
import 'package:synclist/authentication/forgot_password.dart';
import 'package:synclist/common_widgets/status_bar_page.dart';

// SVG
import 'package:flutter_svg/flutter_svg.dart';

// --------------------------------------------------------------------------------------------
// CLASS: LOGIN PAGE
// --------------------------------------------------------------------------------------------
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

// --------------------------------------------------------------------------------------------
// CLASS: LOGIN PAGE STATE
// --------------------------------------------------------------------------------------------
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  // ---------------------- METHOD: TRY SUBMIT ----------------------
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate(); // Validate form fields
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isValid) return; // If form is not valid, exit the method

    _formKey.currentState!.save();

    // ---------------------- Try Login ----------------------
    try {
      FirebaseController firebaseController = FirebaseController();

      await firebaseController.login(_email, _password, context);
    }
    // ---------------------- CATCH ERROR ----------------------
    catch (e) {
      if (!mounted) {
        return;
      }

      showMessage(context, "Error logging in: ${e.toString()}");
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

  // ---------------------- METHOD: BUILD WIDGET ----------------------
  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: 'Login',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ---------------------------------------------------------------------------------------- HEADER
                    Text(
                      "Login to your account",
                      style: AppFonts.headerText(context),
                    ),

                    const SizedBox(height: 10),

                    // ---------------------------------------------------------------------------------------- SUBHEADER
                    Text(
                      "Welcome back! Please enter your details.",
                      style: AppFonts.subHeadingText(context),
                    ),

                    const SizedBox(height: 40),

                    // ---------------------------------------------------------------------------------------- EMAIL FIELD
                    TextFormField(
                      key: const ValueKey('email'),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: AppFonts.textUnfocused(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
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

                    const SizedBox(height: 20),

                    // ---------------------------------------------------------------------------------------- PASSWORD FIELD
                    TextFormField(
                      key: const ValueKey('password'),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: AppFonts.textUnfocused(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),

                    const SizedBox(height: 10),

                    // ---------------------------------------------------------------------------------------- FORGOT PASSWORD LINK
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            slideTransitionRoute(const ForgotPassword()),
                          );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: AppFonts.orangeLinkText,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------------------------------------------------------------------------------- LOGIN BUTTON
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: _trySubmit,
                      color: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Login",
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    // ---------------------------------------------------------------------------------------- SIGNUP LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: AppFonts.subHeadingText(context),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to the Signup Page
                            Navigator.push(
                              context,
                              slideTransitionRoute(const Signup()),
                              /* MaterialPageRoute(
                                  builder: (context) => const Signup(),
                                ), */
                            );
                          },
                          child: const Text(
                            "Sign Up",
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
    );
  }
}

// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/utils/utils.dart';
import 'signup.dart';
import 'package:household_groceries/authentication/forgotPassword.dart';
import 'package:household_groceries/common_widgets/statusBarPage.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return;
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
                    const Text(
                      "Login to your account",
                      style: AppFonts.blackHeaderText,
                    ),

                    const SizedBox(height: 10),

                    // ---------------------------------------------------------------------------------------- SUBHEADER
                    Text(
                      "Welcome back! Please enter your details.",
                      style: AppFonts.blackSubHeadingText,
                    ),

                    const SizedBox(height: 40),

                    // ---------------------------------------------------------------------------------------- EMAIL FIELD
                    TextFormField(
                      key: const ValueKey('email'),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: AppFonts.blackTextFieldUnfocussed,
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
                        labelStyle: AppFonts.blackTextFieldUnfocussed,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
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

                    // ---------------------------------------------------------------------------------------- SIGNUP LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: AppFonts.blackSubHeadingText,
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

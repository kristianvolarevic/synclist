// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/utils/utils.dart';

// Firebase Imports
import 'package:firebase_auth/firebase_auth.dart';

// --------------------------------------------------------------------------------------------
// CLASS: FORGOT PASSWORD PAGE
// --------------------------------------------------------------------------------------------
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

// --------------------------------------------------------------------------------------------
// CLASS: FORGOT PASSWORD PAGE STATE
// --------------------------------------------------------------------------------------------
class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _showResendLink = false;

  // ---------------------- METHOD: TRY SUBMIT ----------------------
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate(); // Validate form fields
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isValid) return; // If form is not valid, exit the method

    _formKey.currentState!.save();

    // ---------------------- Try Sending Link ----------------------
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);

      if (mounted) {
        _showSuccessDialog(_email);

        setState(() {
          _showResendLink = true;
        });
      }
    }
    // ---------------------- CATCH ERROR ----------------------
    catch (e) {
      if (!mounted) {
        return;
      }

      showMessage(context, "Failed to send reset email: ${e.toString()}");
    }
  }

  // ---------------------- METHOD: SHOW SUCCESS DIALOG ----------------------
  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Email Sent", style: AppFonts.headerText(context)),
        content: Text(
          "A password reset link has been sent to $email. Please check your inbox and spam folder.",
          style: AppFonts.subHeadingText(context),
        ),
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

  // ---------------------- METHOD: BUILD WIDGET ----------------------
  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: "Forgot Password",
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
                      "Reset your password",
                      style: AppFonts.headerText(context),
                    ),

                    const SizedBox(height: 10),

                    // ---------------------------------------------------------------------------------------- SUBHEADER
                    Text(
                      "Enter your email address and we'll send you a link to reset your password.",
                      style: AppFonts.subHeadingText(context),
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

                    // ---------------------------------------------------------------------------------------- RESEND LINK
                    if (_showResendLink)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _trySubmit();
                          },
                          child: const Text(
                            'Resend Link',
                            style: AppFonts.orangeLinkText,
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),

                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: _trySubmit,
                      color: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Send Link",
                        style: AppFonts.whiteTextField,
                      ),
                    ),

                    const SizedBox(height: 30),
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

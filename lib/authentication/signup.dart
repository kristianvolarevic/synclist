import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- FULL SIGN UP PAGE IMPLEMENTATION ---
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // Close keyboard

    if (isValid) {
      _formKey.currentState!.save();
      // Use _fullName, _email, and _password for user registration
      print(
        'Registration attempted: Name: $_fullName, Email: $_email, Password: $_password',
      );

      // In a real app, you would call your registration service
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! (Simulated)')),
      );
      // Optionally navigate to the main app screen after successful signup
    }
  }

  // Helper widget to build consistent text fields
  Widget buildInputField({
    required String label,
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
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, size: 20),
          ),
        ),
        body: Center(
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
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sign up now to get started!",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 40),

                      // Full Name
                      buildInputField(
                        key: const ValueKey('fullname'),
                        label: 'Full Name',
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
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Already have an account link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          TextButton(
                            onPressed: () {
                              // Go back to the previous screen (which is likely the Welcome or Login page)
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                              ),
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
    );
  }
}

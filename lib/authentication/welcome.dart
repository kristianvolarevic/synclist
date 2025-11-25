import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.orangeAccent,
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
                      children: <Widget>[
                        const Text(
                          "Welcome",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Collaborate with your household members and manage your groceries efficiently!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png", // placeholder image
                          ), // Flutter Dash image
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        // Login Button
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Sign Up Button
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );
                          },
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
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
    );
  }
}

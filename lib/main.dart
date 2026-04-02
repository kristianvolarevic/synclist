import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'authentication/welcome.dart';
import 'home/home.dart';
import 'utils/licenses.dart';
import 'package:household_groceries/utils/utils.dart';
import 'package:household_groceries/utils/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register licenses
  AppLicenses.registerAllLicenses();

  // Initialize theme mode
  await ThemeController.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.themeMode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'Household Groceries',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              surface: Colors.white,
              onSurface: Colors.black,
              secondary: Colors.orangeAccent,
              onInverseSurface: Colors.black12,
              inverseSurface: Colors.grey,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              surface: Color.fromARGB(255, 63, 62, 62),
              onSurface: Colors.white,
              secondary: Color.fromARGB(255, 255, 140, 0), // Dark Orange
              onInverseSurface:
                  Colors.white12, // White for dark mode inverse surface
              inverseSurface: Colors.black,
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User? user = snapshot.data;
                bool isVerified = FirebaseController().isUserVerified(user);

                if (!isVerified) {
                  // Not verified users go to Welcome screen
                  return const Welcome();
                } else {
                  // Verified users go to Home screen
                  return const Home();
                }
              } else {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      },
    );
  }
}

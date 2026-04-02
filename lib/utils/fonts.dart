import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  // Font Family
  static const String primaryFont = 'Quicksand';

  // Button text style with white color
  static const TextStyle whiteTextField = TextStyle(
    color: Colors.white,
    fontFamily: primaryFont,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const TextStyle blackTextFieldUnfocussed = TextStyle(
    color: Colors.black,
    fontFamily: primaryFont,
    fontWeight: FontWeight.w300,
    fontSize: 18,
  );

  // Orange link text style
  static const TextStyle orangeLinkText = TextStyle(
    color: Colors.orangeAccent,
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  // White title text style
  static const TextStyle whiteTitleText = TextStyle(
    color: Colors.white,
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );

  static TextStyle cardHeaderText(BuildContext context) => TextStyle(
    fontSize: 20,
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle cardSubHeadingText(BuildContext context) => TextStyle(
    fontSize: 15,
    fontFamily: primaryFont,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
  );

  static TextStyle headerText(BuildContext context) => TextStyle(
    fontSize: 30,
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle subHeadingText(BuildContext context) => TextStyle(
    fontSize: 18,
    fontFamily: primaryFont,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
}

import 'package:flutter/material.dart';
import 'colors.dart';

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

  // Black header text style
  static const TextStyle blackHeaderText = TextStyle(
    fontSize: 30,
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Black card header text style
  static const TextStyle blackCardHeaderText = TextStyle(
    fontSize: 20,
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // White header text style
  static const TextStyle whiteHeaderText = TextStyle(
    fontSize: 30,
    fontFamily: primaryFont,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Black sub-heading text style
  static const TextStyle blackSubHeadingText = TextStyle(
    fontSize: 15,
    fontFamily: primaryFont,
    fontWeight: FontWeight.w600,
    color: AppColors.grey700,
  );

  // Black card sub-heading text style
  static const TextStyle blackCardSubHeadingText = TextStyle(
    fontSize: 12,
    fontFamily: primaryFont,
    fontWeight: FontWeight.w600,
    color: AppColors.grey700,
  );

  // White sub-heading text style
  static const TextStyle whiteSubHeadingText = TextStyle(
    fontSize: 15,
    fontFamily: primaryFont,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
  );

  // Orange link text style
  static const TextStyle orangeLinkText = TextStyle(
    color: AppColors.contrast,
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
}

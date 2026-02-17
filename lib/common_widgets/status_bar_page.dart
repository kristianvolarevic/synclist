import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:household_groceries/utils/utils.dart';

class StatusBarPage extends StatelessWidget {
  final String title;
  final IconButton leading;
  final Widget? trailing;
  final Widget body;

  const StatusBarPage({
    super.key,
    required this.title,
    required this.leading,
    required this.body,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // For iOS
      ),
      child: Scaffold(
        // ---------------------------------------------------------------------------------------- APP BAR
        appBar: AppBar(
          title: Text(title),
          titleTextStyle: AppFonts.whiteTitleText,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: leading,
          actions: [if (trailing != null) trailing!],
        ),
        body: body,
      ),
    );
  }
}

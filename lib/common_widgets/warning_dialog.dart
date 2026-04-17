// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:synclist/utils/utils.dart';

class WarningDialog extends StatefulWidget {
  final String warningMessage;

  const WarningDialog({super.key, required this.warningMessage});

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Warning"),
      content: Text(widget.warningMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          style: TextButton.styleFrom(
            textStyle: AppFonts.subHeadingText(context),
            foregroundColor: AppColors.primary,
          ),
          child: const Text("Yes"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          style: TextButton.styleFrom(
            textStyle: AppFonts.subHeadingText(context),
            foregroundColor: AppColors.primary,
          ),
          child: const Text("No"),
        ),
      ],
    );
  }
}

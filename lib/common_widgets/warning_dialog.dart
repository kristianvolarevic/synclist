// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

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
          child: const Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text("No"),
        ),
      ],
    );
  }
}

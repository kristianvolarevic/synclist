// --------------------------------------------------------------------------------------------
// IMPORTS
// --------------------------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';

// App Imports
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/models/shopping_list.dart';
import 'package:household_groceries/utils/utils.dart';

class ListShare extends StatefulWidget {
  final ShoppingList list;

  const ListShare({super.key, required this.list});

  @override
  State<ListShare> createState() => _ListShareState();
}

class _ListShareState extends State<ListShare> {
  bool _isShared = false;
  bool _isLoading = false;
  String _code = '';

  void _toggleShare() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (!_isShared) {
        _code = await FirebaseController().generateUniqueCode(widget.list);
      } else {
        print("unshare");
      }
    } catch (e) {
      // TODO
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarPage(
      title: "Share",
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, size: 20),
      ),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Share List", style: AppFonts.blackSubHeadingText),
                  const SizedBox(width: 12),
                  Switch(
                    value: _isShared,
                    activeThumbColor: AppColors.contrast,
                    onChanged: (val) {
                      _toggleShare();
                      setState(() => _isShared = val);
                    },
                  ),
                ],
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : _isShared
                  ? Row(
                      children: [
                        Text(
                          'Share ID: $_code',
                          style: AppFonts.blackSubHeadingText,
                        ),
                      ],
                    )
                  : Row(),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------------
// IMPORTS
// ----------------------------------------------------------------------------
// Flutter Imports
import 'package:flutter/material.dart';
import 'package:household_groceries/common_widgets/list_card.dart';
import 'package:image_picker/image_picker.dart';

// App Imports
import 'package:household_groceries/common_widgets/status_bar_page.dart';
import 'package:household_groceries/utils/utils.dart';

// ----------------------------------------------------------------------------
// CLASS: PROFILE
// ----------------------------------------------------------------------------
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // TODO: Implement image upload and update user profile picture in Firebase
      print("Selected image path: ${image.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseController().userDetailsStream(
        FirebaseController().auth.currentUser!.uid,
      ),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(color: AppColors.primary);
        }

        if (!userSnapshot.hasData) return const SizedBox.shrink();

        final user = userSnapshot.data!;
        return StatusBarPage(
          title: user.fullName,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, size: 20),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.account_circle, size: 100),
                      Positioned(
                        bottom: 0,
                        right: -10,
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            minimumSize: Size(32, 32),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Owned Lists', style: AppFonts.blackSubHeadingText),
                const Divider(),

                if (user.lists.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("No lists have been created yet."),
                  ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: user.lists.length,
                  itemBuilder: (context, index) {
                    final listId = user.lists[index];

                    return FutureBuilder(
                      future: FirebaseController().fetchListWithId(listId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const LinearProgressIndicator(
                            color: AppColors.primary,
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final shoppingList = snapshot.data!;
                        return ListCard(list: shoppingList);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

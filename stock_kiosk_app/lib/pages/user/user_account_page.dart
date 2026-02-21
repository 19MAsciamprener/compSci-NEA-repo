// material imports
import 'package:flutter/material.dart';
// internal logic and widget imports
import 'package:stock_kiosk_app/logic/auth/logout_logic.dart';
import 'package:stock_kiosk_app/widgets/back_button.dart';
import 'package:stock_kiosk_app/widgets/user/display_details_stream.dart';
import 'package:stock_kiosk_app/widgets/user/coin_values.dart';
import 'package:stock_kiosk_app/widgets/user/profile_picture_widget.dart';
// internal page imports
import 'package:stock_kiosk_app/pages/user/change_password_page.dart';
import 'package:stock_kiosk_app/pages/user/profile_settings_page.dart';

class UserAccountPage extends StatefulWidget {
  // User Account Page showing profile picture, name, email, and date of birth, with menu for settings, password change, and logout
  //(stateful as user data can change)
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  void _handleMenuSelection(BuildContext context, String value) {
    //function to handle menu selections (switch case for different options)
    switch (value) {
      case 'profile settings':
        Navigator.push(
          //navigate to profile settings page (allows user to return to account page)
          context,
          MaterialPageRoute(builder: (context) => const UserSettingsPage()),
        );
        break;

      case 'change password':
        Navigator.push(
          //navigate to change password page
          //allows user to return to account page (unless they change password and are logged out)
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
        break;

      case 'logout': //log out user and navigate to standby page, removing all previous routes
        logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: PagePageBackButton(),
        title: const Text(
          'Account Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            //list of menu options for profile settings, change password, and logout.
            // _handleMenuSelection with value of the selected option called on selection
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.menu, color: Colors.white, size: 48),
            onSelected: (value) {
              _handleMenuSelection(context, value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile settings',
                child: Text(
                  'Profile Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const PopupMenuDivider(
                height: 1,
              ), //divider between options (adds line for UI clarity)

              const PopupMenuItem(
                value: 'change password',
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const PopupMenuDivider(
                height: 1,
              ), //divider between options (adds line for UI clarity)

              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 96),
            SizedBox(
              width: 256,
              height: 256,
              child: ProfilePictureWidget(context, size: 96),
            ),
            SizedBox(height: 24),

            DisplayDetailsStream(), //custom widget to display user details (name, email, date of birth) with real-time updates from Firestore

            SizedBox(height: 64),

            CoinList(), //custom widget to display coin values (image and text based on coin type)
          ],
        ),
      ),
    );
  }
}

// material imports
import 'package:flutter/material.dart';
// firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// internal page imports
import 'package:stock_kiosk_app/pages/user/change_password_page.dart';
import 'package:stock_kiosk_app/pages/user/profile_settings_page.dart';
import 'package:stock_kiosk_app/pages/global/standby_page.dart';
import 'package:stock_kiosk_app/widgets/user/coin_values.dart';
import 'package:stock_kiosk_app/widgets/user/profile_picture_widget.dart';

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
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StandbyPage()),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Colors.white,
            size: 48,
          ),
          onPressed: () {
            //navigate back to previous page
            Navigator.pop(context);
          },
        ),
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

            StreamBuilder(
              //stream builder to listen for real-time updates to user document in firestore
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                //build UI based on snapshot state
                if (snapshot.hasData) {
                  var userDocument = snapshot.data!;
                  return Column(
                    children: [
                      Text(
                        //display user full name (concatenate first and last name from firestore document)
                        '${userDocument['first_name']} ${userDocument['last_name']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        //display user email address from firestore document (not FirebaseAuth user object to ensure real-time updates)
                        userDocument['email'],
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        //display user date of birth from firestore document (formatted as YYYY-MM-DD unless null)
                        userDocument['date_of_birth'] != null
                            ? (userDocument['date_of_birth'] as Timestamp)
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  .split(
                                    ' ',
                                  )[0] //from Timestamp to DateTime to local string, take date part only (Timestamp stored in firestore)
                            : 'Not set',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator(); //show loading indicator while waiting for data or if no data
                  //[CHANGE THIS MATTIA YOU LAZY BUM]
                }
              },
            ),

            SizedBox(height: 64),

            CoinValues(
              coinType: 'drink',
            ), //custom widget to display coin values (image and text based on coin type)

            SizedBox(height: 24),
            CoinValues(
              coinType: 'food',
            ), //custom widget to display coin values (image and text based on coin type)

            SizedBox(height: 24),

            CoinValues(
              coinType: 'library',
            ), //custom widget to display coin values (image and text based on coin type)

            SizedBox(height: 24),

            CoinValues(
              coinType: 'stationery',
            ), //custom widget to display coin values (image and text based on coin type)
          ],
        ),
      ),
    );
  }
}

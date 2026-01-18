import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_kiosk_app/pages/global/change_password_page.dart';
import 'package:stock_kiosk_app/pages/user/profile_settings_page.dart';
import 'package:stock_kiosk_app/pages/global/standby_page.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserSettingsPage()),
        );
        break;

      case 'change password':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
        break;

      case 'logout':
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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Account Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
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

              const PopupMenuDivider(height: 1),

              const PopupMenuItem(
                value: 'change password',
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const PopupMenuDivider(height: 1),

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
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: 'lib/assets/images/Default_pfp.jpg',
                  image:
                      'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
                  fit: BoxFit.cover,
                  width: 96,
                  height: 96,
                ),
              ),
            ),
            SizedBox(height: 24),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var userDocument = snapshot.data!;
                  return Column(
                    children: [
                      Text(
                        '${userDocument['first_name']} ${userDocument['last_name']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        FirebaseAuth.instance.currentUser!.email ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        userDocument['date_of_birth'] != null
                            ? (userDocument['date_of_birth'] as Timestamp)
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]
                            : 'Not set',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

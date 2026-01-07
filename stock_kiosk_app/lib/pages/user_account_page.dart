import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_kiosk_app/pages/user_settings_page.dart';
import 'package:stock_kiosk_app/logic/pfp_upload.dart';

import 'package:stock_kiosk_app/pages/standby_page.dart';

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
          PopupMenuButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 48),
            onSelected: (value) {
              _handleMenuSelection(context, value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile settings',
                child: Text('Profile Settings'),
              ),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                pickAndUploadImage(context);
                setState(() {});
              },
              child: const Text('Upload Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_kiosk_app/pages/user/account_settings_page.dart';
import 'package:stock_kiosk_app/pages/user/user_settings_page.dart';
import 'package:stock_kiosk_app/logic/pfp_upload.dart';

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

      case 'account settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
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
                value: 'account settings',
                child: Text(
                  'Account Settings',
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
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                minimumSize: WidgetStateProperty.all(Size(200, 80)),
              ),
              child: const Text('Upload Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}

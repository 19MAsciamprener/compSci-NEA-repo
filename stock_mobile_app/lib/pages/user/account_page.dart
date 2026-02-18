import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_mobile_app/widgets/account_page_widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  void _handleMenuSelection(BuildContext context, String value) {
    //function to handle menu selections (switch case for different options)
    switch (value) {
      case 'profile settings':
        break;

      case 'change password':
        break;

      case 'logout': //log out user and navigate to standby page, removing all previous routes

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

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
            SizedBox(height: 48),
            SizedBox(
              width: 128,
              height: 128,
              child: ProfilePictureWidget(context, size: 96),
            ),
            SizedBox(height: 24),

            DisplayDetailsStream(), //custom widget to display user details (name, email, date of birth) with real-time updates from Firestore

            SizedBox(height: 48),

            CoinList(), //custom widget to display coin values (image and text based on coin type)
          ],
        ),
      ),
    );
  }
}

class CoinList extends StatelessWidget {
  const CoinList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('wallets')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        return Column(
          children: [
            coinRow('drink', data),
            const SizedBox(height: 24),
            coinRow('food', data),
            const SizedBox(height: 24),
            coinRow('library', data),
            const SizedBox(height: 24),
            coinRow('stationery', data),
          ],
        );
      },
    );
  }
}

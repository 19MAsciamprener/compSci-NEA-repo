import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Widget coinRow(String coinType, Map<String, dynamic> data) {
    final value = data['${coinType}_coin'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Image.asset(
            'assets/images/${coinType}_coin.ico',
            width: 72,
            height: 72,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              '$value Tokens',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayDetailsStream extends StatelessWidget {
  const DisplayDetailsStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
    );
  }
}

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget(this.context, {super.key, this.size = 96});
  final BuildContext context;
  final double size;

  @override
  Widget build(BuildContext context, {double? size}) {
    return ClipOval(
      child: Image.network(
        //profile image URL with refresh key to prevent caching
        'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
        width: size ?? 96,
        height: size ?? 96,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          //show default profile image while loading or if there is an error (prevents blank space or broken image icon)
          if (loadingProgress == null) return child;
          return Image.asset(
            'assets/images/default_pfp.jpg',
            width: size ?? 96,
            height: size ?? 96,
            fit: BoxFit.cover,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          //show default profile image if there is an error loading the image (prevents broken image icon)
          return Image.asset(
            'assets/images/default_pfp.jpg',
            width: size ?? 96,
            height: size ?? 96,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

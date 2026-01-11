import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/pages/user/user_account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 96,
        title: const Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserAccountPage()),
                );
              },
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
          ),
        ],
      ),
      body: Center(
        child: Text(
          'User Home Page, to be implemented',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

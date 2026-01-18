// TO BE IMPLEMENTED [MATTIA YOU STUPID FUCKING IDIOT GET A MOVE ON WITH YOUR LIFE JESUS CHRIST]

// material imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:firebase_auth/firebase_auth.dart';
//page imports
import 'package:stock_kiosk_app/pages/user/user_account_page.dart';

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
                // tap profile picture to go to account page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserAccountPage()),
                );
              },
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  //profile picture with default placeholder while loading or if no picture set
                  placeholder: 'lib/assets/images/Default_pfp.jpg',
                  image:
                      'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
                  //user profile picture from server with cache-busting query parameter
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
          'User Home Page, to be implemented', //HURRY THE FUCK UP MATTIA (STUPID TWAT)
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

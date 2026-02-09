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
                child: Image.network(
                  //profile image URL with refresh key to prevent caching
                  'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    //show default profile image while loading or if there is an error (prevents blank space or broken image icon)
                    if (loadingProgress == null) return child;
                    return Image.asset(
                      'lib/assets/images/default_pfp.jpg',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    //show default profile image if there is an error loading the image (prevents broken image icon)
                    return Image.asset(
                      'lib/assets/images/default_pfp.jpg',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    );
                  },
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

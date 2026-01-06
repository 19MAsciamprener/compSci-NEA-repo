import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/pages/user_account_page.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserAccountPage()),
              );
            },
            icon: Icon(Icons.person, size: 56, color: Colors.white),
            iconSize: 56,
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

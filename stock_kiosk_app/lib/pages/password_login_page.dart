import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/pages/password_reset_page.dart';

class PasswordLoginPage extends StatelessWidget {
  const PasswordLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Login with Password',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 128),
            Text(
              'Username:',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(height: 2),

            SizedBox(
              width: 400,
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 64),

            Text(
              'Password:',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(height: 2),
            SizedBox(
              width: 400,
              child: TextField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).primaryColor,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 256),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 100),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordResetPage()),
              );
            },
            child: Text(
              'Forgotten your password?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

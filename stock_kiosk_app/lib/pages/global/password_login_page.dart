//material import
import 'package:flutter/material.dart';
//logic imports
import 'package:stock_kiosk_app/logic/auth/sign_in_logic.dart';
//internal page imports
import 'package:stock_kiosk_app/pages/global/password_reset_page.dart';
import 'package:stock_kiosk_app/pages/global/qr_login_page.dart';

class PasswordLoginPage extends StatefulWidget {
  //stateful page for user login with email and password (so that we can manage the input fields)
  const PasswordLoginPage({super.key});

  @override
  State<PasswordLoginPage> createState() => _PasswordLoginPageState();
}

class _PasswordLoginPageState extends State<PasswordLoginPage> {
  //email and password controllers for the input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            //back button
            Icons.keyboard_backspace,
            color: Colors.white,
            size: 48,
          ),
          onPressed: () {
            //return to QR login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => QrLoginPage()),
            );
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
          //column to hold input fields on left side (strange alignment is intentional)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 128),
            Text('Email:', style: TextStyle(color: Colors.white, fontSize: 30)),
            SizedBox(height: 2),

            SizedBox(
              width: 400,
              child: TextField(
                controller: emailController,
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
                controller: passwordController,
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
              // center the submit button
              child: ElevatedButton(
                onPressed: () async {
                  await loginUserWithEmailAndPassword(
                    // login function from sign_in_logic.dart
                    emailController,
                    passwordController,
                    context,
                  );
                },
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  minimumSize: WidgetStateProperty.all(Size(200, 80)),
                ),
                child: Text('SUBMIT'),
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
              //navigate to password reset page (allows user to go back)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordResetPage()),
              );
            },
            child: Text(
              'Forgotten your password?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                // takes theme style from main.dart and customizes color and text size
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

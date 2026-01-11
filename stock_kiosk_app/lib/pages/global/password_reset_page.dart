//material import
import 'package:flutter/material.dart';
//internal logic imports
import 'package:stock_kiosk_app/logic/sign_in_logic.dart';

class PasswordResetPage extends StatefulWidget {
  //stateful page for password reset (email input)
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  // controller for email input field
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // back button
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
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please enter your email:',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: TextField(
                controller: emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 72),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  // submit button to send password reset email
                  await sendPasswordResetEmail(emailController, context);
                },
                // theme from main.dart
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  minimumSize: WidgetStateProperty.all(Size(200, 80)),
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
    );
  }
}

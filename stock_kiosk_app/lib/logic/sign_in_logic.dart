import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_kiosk_app/pages/user/user_home_page.dart';

Future<void> kioskSignInWithUid(String idToken, BuildContext context) async {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('Signing in...')));

  final serverUrl = 'http://stock-tokenrequest.matnlaws.co.uk/getCustomToken';

  final response = await http.post(
    Uri.parse(serverUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'token': idToken}),
  );

  if (response.statusCode != 200) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to get custom token from server ${response.body}',
        ),
      ),
    );
    return;
  }

  final responseData = jsonDecode(response.body);
  final customToken = responseData['customToken'];

  try {
    await FirebaseAuth.instance.signInWithCustomToken(customToken);

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => UserHomePage()),
      (route) => false,
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error during sign-in: $e')));
    return;
  }

  if (!context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('Login successful')));
}

Future<void> loginUserWithEmailAndPassword(
  TextEditingController emailController,
  TextEditingController passwordController,
  BuildContext context,
) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Login successful!')));
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
  }
}

Future<void> sendPasswordResetEmail(
  TextEditingController emailController,
  BuildContext context,
) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim(),
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password reset email sent!')));
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset failed: ${e.message}')),
    );
  }
}

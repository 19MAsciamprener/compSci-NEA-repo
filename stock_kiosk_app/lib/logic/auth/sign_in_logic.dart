// material imports
import 'package:flutter/material.dart';
// dart imports
import 'dart:convert';
// external package imports
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

// firebase imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// internal page imports
import 'package:stock_kiosk_app/pages/user/user_home_page.dart';

Future<void> onQrScanned(
  // function to handle QR code scanning for kiosk sign-in
  BuildContext context,
  BarcodeCapture capture,
  bool scanned,
  String? idToken,
  // takes in context, barcode capture data, scanned flag and idToken
) async {
  if (scanned) return; // if already scanned, return
  final List<Barcode> barcodes = capture.barcodes;
  for (final barcode in barcodes) {
    idToken = barcode.rawValue
        ?.trim(); //get the scanned token, remove whitespace
    if (idToken != null) {
      // if a token was scanned, set scanned to true to prevent further scans
      scanned = true;
      break;
    }
  }
  if (idToken == null) {
    //if no token was scanned, show error
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('No QR code detected.')));
    return;
  }
  {
    final backendTokenDoc = await FirebaseFirestore
        .instance //access Firestore, look for the scanned token
        .collection('LoginTokens')
        .doc(idToken)
        .get();

    if (!backendTokenDoc.exists) {
      //if the token does not exist in the database, show error
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid QR code scanned.')));
      return;
    }

    final docData = backendTokenDoc.data()!; //get the document data
    final expiresAt = (docData['timestamp'] as Timestamp).toDate().add(
      Duration(minutes: 5),
    );

    if (DateTime.now().isAfter(expiresAt)) {
      //compare current time to expiry time, show error if expired
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('This QR code has expired.')));
      return;
    }
    if (!context.mounted) return;
    await kioskSignInWithUid(
      idToken,
      context,
    ); //call sign-in logic with the scanned token if all checks passed
  }
}

Future<void> kioskSignInWithUid(String idToken, BuildContext context) async {
  // function to sign in user with scanned kiosk token
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Signing in...')),
  ); // show signing in message (so that user knows something is happening)

  final serverUrl =
      'http://stock-tokenrequest.matnlaws.co.uk/getCustomToken'; // backend server URL to exchange scanned token for Firebase custom token

  final response = await http.post(
    // make HTTP POST request to backend server
    Uri.parse(serverUrl),
    headers: {'Content-Type': 'application/json'}, // set content type to JSON
    body: jsonEncode({
      'token': idToken,
    }), // send scanned token in request body as JSON
  );

  if (response.statusCode != 200) {
    // check for successful response from server (200 = success)
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to get custom token from server ${response.body}', // show error message with response body
        ),
      ),
    );
    return;
  }

  final responseData = jsonDecode(response.body);
  final customToken =
      responseData['customToken']; // extract custom token from response data

  try {
    await FirebaseAuth.instance.signInWithCustomToken(
      customToken,
    ); // sign in user with Firebase custom token

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      //if successful, navigate to user home page and remove all previous routes (to prevent back navigation)
      context,
      MaterialPageRoute(builder: (context) => UserHomePage()),
      (route) => false,
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error during sign-in: $e')),
    ); // show error message if sign-in fails
    return;
  }

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Login successful')),
  ); // show success message after successful sign-in
}

Future<void> loginUserWithEmailAndPassword(
  // function to log in user with email and password
  TextEditingController emailController,
  TextEditingController passwordController,
  BuildContext context,
  // takes in email and password controllers, and context
) async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    // check email and password fields are not empty
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please enter email and password')));
    return;
  }

  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(emailController.text.trim())) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid email address.')),
    );
    return;
  }

  if (passwordController.text.length < 6) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password must be at least 6 characters long.'),
      ),
    );
    return;
  }

  if (passwordController.text.length > 128) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password must not exceed 128 characters.')),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      // sign in with email and password (firebase auth method using text from controllers)
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ); //trim() to remove any leading/trailing whitespace

    if (!context.mounted || FirebaseAuth.instance.currentUser == null) {
      return; // Login failed or context is not mounted
    }

    Navigator.pushAndRemoveUntil(
      //navigate to user home page on successful login (removing all previous pages so user can't go back to login)
      context,
      MaterialPageRoute(builder: (context) => UserHomePage()),
      (route) => false,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful!')),
    ); // show success message
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: ${e.message}')),
    ); // show error message if login fails
  }
}

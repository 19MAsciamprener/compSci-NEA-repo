import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_kiosk_app/pages/user/user_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> onQrScanned(
  BuildContext context,
  BarcodeCapture capture,
  bool scanned,
  String? idToken,
) async {
  if (scanned) return;
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
      idToken!,
      context,
    ); //call sign-in logic with the scanned token if all checks passed
  }
}

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

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_kiosk_app/pages/password_login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_kiosk_app/pages/user_home_page.dart';

class QrLoginPage extends StatefulWidget {
  const QrLoginPage({super.key});

  @override
  State<QrLoginPage> createState() => _QrLoginPageState();
}

class _QrLoginPageState extends State<QrLoginPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool scanned = false;
  String? idToken;

  Future<void> kioskSignInWithUid(String idToken) async {
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
      if (!mounted) return;
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

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserHomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error during sign-in: $e')));
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Login successful')));
  }

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
          'Scan QR Code to Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) async {
              if (scanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                idToken = barcode.rawValue?.trim();
                if (idToken != null) {
                  scanned = true;
                  break;
                }
              }
              {
                final backendTokenDoc = await FirebaseFirestore.instance
                    .collection('LoginTokens')
                    .doc(idToken)
                    .get();

                if (!backendTokenDoc.exists) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid QR code scanned.')),
                  );
                  return;
                }

                final docData = backendTokenDoc.data()!;
                final expiresAt = (docData['timestamp'] as Timestamp)
                    .toDate()
                    .add(Duration(minutes: 5));

                if (DateTime.now().isAfter(expiresAt)) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('This QR code has expired.')),
                  );
                  return;
                }

                await kioskSignInWithUid(idToken!);
              }
            },
          ),
          Container(color: Theme.of(context).colorScheme.surface),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 600,
                  height: 750,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: MobileScanner(controller: controller),
                ),
              ),
            ),
          ),

          Positioned(
            top: 1000,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Unable to scan your QR code?',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordLoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Login with Password',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

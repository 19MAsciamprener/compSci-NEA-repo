import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatelessWidget {
  const QrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        title: Text('QR Page', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(100, 48),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Center(
        child: QrImageView(
          data: FirebaseAuth.instance.currentUser?.uid ?? 'No UID',
          version: QrVersions.auto,
          foregroundColor: Colors.white,
          size: 400.0,
        ),
      ),
    );
  }
}

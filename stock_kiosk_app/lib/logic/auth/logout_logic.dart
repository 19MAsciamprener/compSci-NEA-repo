import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_kiosk_app/pages/global/standby_page.dart';

void logout(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => StandbyPage()),
    (route) => false,
  );
}

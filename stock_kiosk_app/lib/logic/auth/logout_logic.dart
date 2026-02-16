import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:stock_kiosk_app/logic/provider/cart_provider.dart';
import 'package:stock_kiosk_app/pages/global/standby_page.dart';

void logout(BuildContext context) {
  Provider.of<CartProvider>(context, listen: false).clearCart();
  FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => StandbyPage()),
    (route) => false,
  );
}

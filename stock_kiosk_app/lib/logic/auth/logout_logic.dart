//material imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:firebase_auth/firebase_auth.dart';
//provider imports
import 'package:provider/provider.dart';
import 'package:stock_kiosk_app/logic/provider/cart_provider.dart';
import 'package:stock_kiosk_app/logic/provider/admin_provider.dart';
//internal page imports
import 'package:stock_kiosk_app/pages/global/standby_page.dart';

void logout(BuildContext context) {
  Provider.of<CartProvider>(context, listen: false).clearCart();
  Provider.of<AdminProvider>(context, listen: false).logout();
  FirebaseAuth.instance.signOut();

  //clears cart, removes any admin privileges, and signs out of firebase auth, then navigates back to standby page

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => StandbyPage()),
    (route) => false,
  );
}

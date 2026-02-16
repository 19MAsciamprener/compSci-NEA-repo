//material imports
import 'package:flutter/material.dart';
//provider imports
import 'package:provider/provider.dart';
import 'package:stock_kiosk_app/logic/provider/admin_provider.dart';
//internal page imports
import 'package:stock_kiosk_app/pages/admin/admin_home_page.dart';

void openAdminPage(BuildContext context) {
  final isAdmin = checkAdmin(context); //gets admin provider info

  if (!isAdmin) {
    //checks admin
    ScaffoldMessenger.of(
      //if !admin, denied
      context,
    ).showSnackBar(const SnackBar(content: Text('Admin access required')));
    return;
  }

  Navigator.push(
    //if admin, open admin page
    context,
    MaterialPageRoute(builder: (_) => const AdminHomePage()),
  );
}

bool checkAdmin(BuildContext context) {
  final admin = Provider.of<AdminProvider>(
    context,
    listen: false,
  ); //gets admin provider info

  return admin.isAdmin; //returns true if admin, false if not
}

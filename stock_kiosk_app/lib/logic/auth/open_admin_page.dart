import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_kiosk_app/logic/provider/admin_provider.dart';
import 'package:stock_kiosk_app/pages/admin/admin_home_page.dart';

void openAdminPage(BuildContext context) {
  final admin = Provider.of<AdminProvider>(context, listen: false);

  if (!admin.isAdmin) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Admin access required')));
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AdminHomePage()),
  );
}

// TO BE IMPLEMENTED

import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/logic/auth/open_admin_page.dart';
import 'package:stock_kiosk_app/pages/admin/new_item_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    if (!checkAdmin(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Admin access required')));
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'ADMIN Home Page, to be implemented',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 200),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewItemPage()),
                );
              },
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}

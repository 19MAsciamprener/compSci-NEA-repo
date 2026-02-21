// TO BE IMPLEMENTED

import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/widgets/back_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        leading: PagePageBackButton(),
      ),
      body: Center(
        child: Text(
          'Settings Page, to be implemented',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

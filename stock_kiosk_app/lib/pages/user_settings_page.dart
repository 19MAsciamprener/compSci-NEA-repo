import 'package:flutter/material.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          'User Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'User Settings Page Content Here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// TO BE IMPLEMENTED

import 'package:flutter/material.dart';

class UserPurchasePage extends StatelessWidget {
  const UserPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Purchase Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Purchase Page will be implemented here.',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

// TO BE IMPLEMENTED

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/logic/account_transaction_logic.dart';

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
      body: Center(
        child: Column(
          children: [
            Text(
              'Purchase Page will be implemented here.',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),

            ElevatedButton(
              onPressed: () async {
                try {
                  await purchaseItem(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    cost: 10,
                    category: 'drink',
                  );
                  print('Purchase successful');
                } catch (e) {
                  print('Purchase failed: $e');
                }
              },
              child: Text('Test Purchase'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoinList extends StatelessWidget {
  const CoinList({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('wallets')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        return Column(
          children: [
            coinRow('drink', data),
            const SizedBox(height: 24),
            coinRow('food', data),
            const SizedBox(height: 24),
            coinRow('library', data),
            const SizedBox(height: 24),
            coinRow('stationery', data),
          ],
        );
      },
    );
  }

  Widget coinRow(String coinType, Map<String, dynamic> data) {
    final value = data['${coinType}_coin'] ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/${coinType}_coin.ico',
          width: 128,
          height: 128,
        ),
        const SizedBox(width: 48),
        Text(
          '$value Tokens',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

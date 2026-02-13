import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> purchaseItem({
  required String uid,
  required int cost,
  required String category,
}) async {
  final walletRef = FirebaseFirestore.instance.collection('wallets').doc(uid);
  final txRef = walletRef.collection('transactions').doc();

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final walletSnapshot = await transaction.get(walletRef);

    final balance = walletSnapshot['${category}_coin'];

    if (balance < cost) {
      throw Exception('Insufficient funds');
    }

    transaction.update(walletRef, {
      '${category}_coin': balance - cost,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    transaction.set(txRef, {
      'type': 'purchase',
      'amount': -cost,
      'coin': '${category}_coin',
      'timestamp': FieldValue.serverTimestamp(),
    });
  });
}

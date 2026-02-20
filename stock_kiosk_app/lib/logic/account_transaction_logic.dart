//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> purchaseItem({
  //function to handle purchasing an item, deducting coins from user's wallet and recording the transaction in Firestore
  required double cost,
  required String category,
}) async {
  final String uid = FirebaseAuth
      .instance
      .currentUser!
      .uid; //get the current user's UID from Firebase Authentication

  final walletRef = FirebaseFirestore.instance.collection('wallets').doc(uid);
  final txRef = walletRef.collection('transactions').doc();

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    //run a Firestore transaction to ensure atomicity of the operations
    final walletSnapshot = await transaction.get(walletRef);

    final balance = walletSnapshot['${category}_coin'];

    if (balance < cost) {
      throw Exception('Insufficient funds');
    } //check if user has enough coins in the specified category to make the purchase

    transaction.update(
      walletRef,
      {
        '${category}_coin': balance - cost,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ); //update the user's wallet by deducting the cost of the item and updating the timestamp

    transaction.set(
      txRef,
      {
        'type': 'purchase',
        'amount': -cost,
        'coin': '${category}_coin',
        'timestamp': FieldValue.serverTimestamp(),
      },
    ); //record the transaction in a subcollection of the user's wallet document, with details about the transaction type, amount, coin category, and timestamp
  });
} //this transcation ensures that both the wallet update and transaction recording happen atomically

//this prevents issues with concurrent transactions and ensures data consistency in Firestore (ACID database).

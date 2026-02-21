import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> createUser(
  BuildContext context,
  String firstName,
  String lastName,
  String email,
  DateTime? dateOfBirth,
  bool isAdmin,
) async {
  //function to create user in Firestore
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: 'defaultPassword', //set a default password for new users
    );
  } catch (e) {
    //handle errors if user creation fails
    if (!context.mounted) {
      return;
    } //check if context is still valid before showing snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error creating user: $e')));
    return; //exit the function if user creation in Firebase Auth fails
  }
  String uid = FirebaseAuth
      .instance
      .currentUser!
      .uid; //get the UID of the newly created user

  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'date_of_birth': dateOfBirth != null
          ? Timestamp.fromDate(dateOfBirth)
          : null, //convert DateTime to Firestore Timestamp
      'is_admin': isAdmin,
    });
  } catch (e) {
    //handle errors if user creation fails
    if (!context.mounted) {
      return;
    } //check if context is still valid before showing snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error creating user: $e')));
  }
  try {
    FirebaseFirestore.instance
        .collection('wallets')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
          'drink_coin': 0.0,
          'food_coin': 0.0,
          'library_coin': 0.0,
          'stationery_coin': 0.0,
          'updatedAt': Timestamp.now(),
        });

    FirebaseFirestore.instance
        .collection('wallets')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('transactions')
        .doc('0')
        .set({
          'type': 'initial',
          'amount': 0.0,
          'coin_type': 'initial',
          'timestamp': Timestamp.now(),
          'performed_by': 'system',
        });
  } catch (e) {
    if (!context.mounted) {
      return;
    } //check if context is still valid before showing snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error creating wallet: $e')));
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayDetailsStream extends StatelessWidget {
  const DisplayDetailsStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //stream builder to listen for real-time updates to user document in firestore
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        //build UI based on snapshot state
        if (snapshot.hasData) {
          var userDocument = snapshot.data!;
          return Column(
            children: [
              Text(
                //display user full name (concatenate first and last name from firestore document)
                '${userDocument['first_name']} ${userDocument['last_name']}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                //display user email address from firestore document (not FirebaseAuth user object to ensure real-time updates)
                userDocument['email'],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                //display user date of birth from firestore document (formatted as YYYY-MM-DD unless null)
                userDocument['date_of_birth'] != null
                    ? (userDocument['date_of_birth'] as Timestamp)
                          .toDate()
                          .toLocal()
                          .toString()
                          .split(
                            ' ',
                          )[0] //from Timestamp to DateTime to local string, take date part only (Timestamp stored in firestore)
                    : 'Not set',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator(); //show loading indicator while waiting for data or if no data
          //[CHANGE THIS MATTIA YOU LAZY BUM]
        }
      },
    );
  }
}

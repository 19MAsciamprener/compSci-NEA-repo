import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

final idToken = const Uuid().v4();
// String oldIdToken = '';

class _QrPageState extends State<QrPage> {
  Future<String> getIdToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('LoginTokens').doc(idToken).set(
      {'uid': uid, 'timestamp': FieldValue.serverTimestamp()},
    );
    return idToken;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        title: Text('QR Page', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          style: ElevatedButton.styleFrom(
            fixedSize: Size(100, 48),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: FutureBuilder<String>(
              future: getIdToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return QrImageView(
                    data: snapshot.data ?? '',
                    version: QrVersions.auto,
                    backgroundColor: Colors.white,
                    dataModuleStyle: QrDataModuleStyle(color: Colors.black),
                    size: 400.0,
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // oldIdToken = idToken;
              //}
              setState(() {});
            },
            child: Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

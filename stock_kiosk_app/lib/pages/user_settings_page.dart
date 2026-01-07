import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_kiosk_app/logic/pfp_upload.dart';
import 'package:stock_kiosk_app/widgets/user_settings_fields.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> loadUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      if (userDoc.data() != null && userDoc.data()!.containsKey('first_name')) {
        firstNameController.text = userDoc.data()!['first_name'];
      }
      if (userDoc.data() != null && userDoc.data()!.containsKey('last_name')) {
        lastNameController.text = userDoc.data()!['last_name'];
      }
      if (userDoc.data() != null && userDoc.data()!.containsKey('email')) {
        emailController.text = userDoc.data()!['email'];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 128.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 64),
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'lib/assets/images/Default_pfp.jpg',
                        image:
                            'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
                        fit: BoxFit.cover,
                        width: 148,
                        height: 148,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        pickAndUploadImage(context);
                        setState(() {});
                      },
                      child: Text(
                        'edit profile image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),
              UserSettingsFields(
                nameController: firstNameController,
                fieldType: 'First Name',
              ),
              SizedBox(height: 32),
              UserSettingsFields(
                nameController: lastNameController,
                fieldType: 'Last Name',
              ),
              SizedBox(height: 32),
              UserSettingsFields(
                nameController: emailController,
                fieldType: 'Email',
              ),
              SizedBox(height: 64),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    try {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .update({
                            'first_name': firstNameController.text,
                            'last_name': lastNameController.text,
                            'email': emailController.text,
                          });
                    } on Exception catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving changes: $e')),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Changes saved successfully')),
                    );
                  },
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

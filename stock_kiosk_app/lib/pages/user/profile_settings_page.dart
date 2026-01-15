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

  Future<void> changeEmail(String newEmail) async {
    try {
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(
        newEmail,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating email: $e')));
    }
  }

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

  late Future<void> _userDataFuture;
  int _imageRefreshKey = DateTime.now().millisecondsSinceEpoch;
  late String _oldEmail;

  @override
  void initState() {
    super.initState();
    _userDataFuture = loadUserData();
    _oldEmail = emailController.text;
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
                        key: ValueKey(_imageRefreshKey),
                        placeholder: 'lib/assets/images/Default_pfp.jpg',
                        image:
                            'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?v=$_imageRefreshKey',
                        fit: BoxFit.cover,
                        width: 148,
                        height: 148,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await pickAndUploadImage(context);
                        setState(() {
                          _imageRefreshKey =
                              DateTime.now().millisecondsSinceEpoch;
                        });
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
              FutureBuilder(
                future: _userDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading user data',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Column(
                    children: [
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
                    ],
                  );
                },
              ),
              SizedBox(height: 64),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (emailController.text == _oldEmail) {
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
                      setState(() {
                        _userDataFuture = loadUserData();
                      });
                    } else {
                      await changeEmail(emailController.text);
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
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving changes: $e')),
                        );
                      }
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Changes saved successfully.')),
                      );
                      setState(() {
                        _userDataFuture = loadUserData();
                        _oldEmail = emailController.text;
                      });
                    }
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
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

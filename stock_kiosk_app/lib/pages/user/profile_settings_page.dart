// material imports
import 'package:flutter/material.dart';
// firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//internal logic and widget imports
import 'package:stock_kiosk_app/logic/auth/load_user_data.dart';
import 'package:stock_kiosk_app/logic/upload/pfp_upload.dart';
import 'package:stock_kiosk_app/widgets/user/user_settings_fields.dart';
import 'package:stock_kiosk_app/widgets/user/profile_picture_widget.dart';

class UserSettingsPage extends StatefulWidget {
  //stateful widget for user settings page (profile settings fields and pfp are updated on change)
  const UserSettingsPage({super.key});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  //controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  //variable for date of birth
  DateTime? dateOfBirth;

  Future<void> _pickDate() async {
    //function to pick date of birth
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:
          dateOfBirth ??
          DateTime.now(), //default to current date if not previously set
      firstDate: DateTime(1900), //earliest date selectable
      lastDate: DateTime.now(), //latest date selectable is current date
    );

    if (selectedDate != null) {
      //if a date is selected, update the state
      setState(() {
        dateOfBirth = selectedDate;
      });
    }
  }

  Future<void> loadUserData() async {
    //function to load user data from firestore and populate text fields
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (userDoc.exists) {
      //populate text fields with user data
      if (userDoc.data() != null && userDoc.data()!.containsKey('first_name')) {
        firstNameController.text = userDoc.data()!['first_name'];
      }
      if (userDoc.data() != null && userDoc.data()!.containsKey('last_name')) {
        lastNameController.text = userDoc.data()!['last_name'];
      }
      if (userDoc.data() != null && userDoc.data()!.containsKey('email')) {
        emailController.text = userDoc.data()!['email'];
        oldEmail = emailController
            .text; //store old email for comparison or update purposes
      }
      if (userDoc.data() != null &&
          userDoc.data()!.containsKey('date_of_birth')) {
        dateOfBirth = (userDoc.data()!['date_of_birth'] as Timestamp)
            .toDate(); //convert Firestore Timestamp to DateTime
      }
    }
  }

  late Future<void> _userDataFuture; //future for loading user data
  late String oldEmail; //variable to store old email for comparison

  @override
  void initState() {
    //get user data on page load
    super.initState();
    _userDataFuture = loadUserData();
  }

  @override
  void dispose() {
    // dispose controllers when page is closed (good practice to prevent memory leaks)
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
          }, // back button to return to previous page
        ),
        title: const Text(
          'User Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        // allow scrolling if content overflows (stops overflow errors)
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 128.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 64,
              ), // space between top of page and profile image
              Center(
                child: Column(
                  children: [
                    ProfilePictureWidget(context, size: 148),
                    TextButton(
                      onPressed: () async {
                        //button to edit profile image
                        await pickAndUploadImage(
                          context,
                        ); //function to pick and upload new profile image (comes from pfp_upload.dart)
                        setState(() {
                          //update state to refresh profile image with new one (refresh key in URL forces reload)
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
                //build fields once user data is loaded, and show loading indicator/error if needed. When _userDataFuture updates, the field will rebuild with latest data.
                future: _userDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //show loading indicator while waiting for data
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    //show error message if there was an error loading data
                    return Center(
                      child: Text(
                        'Error loading user data',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      //user settings fields for first name, last name, email, and date of birth (component comes from user_settings_fields.dart)
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
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Date of Birth:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${dateOfBirth?.toLocal()}'.split(
                                  ' ',
                                )[0], //date of birth display in YYYY-MM-DD format
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _pickDate(); //calls date picker function
                            },
                            child: Text('Select Date'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 64),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await updateUserData(
                      //function to update user data in firestore (comes from load_user_data.dart)
                      context,
                      firstNameController,
                      lastNameController,
                      emailController,
                      dateOfBirth,
                      oldEmail,
                    );
                    setState(() {
                      //update oldEmail after saving changes (to keep it current)
                      oldEmail = emailController.text;
                    });
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

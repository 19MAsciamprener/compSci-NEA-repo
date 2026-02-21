// material imports
import 'package:flutter/material.dart';
// firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//material imports
// dart imports
import 'dart:io';
//firebase imports
//external package imports
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc() async {
  // function to get user document from firestore (used in multiple places for up to date user data) String uid = FirebaseAuth.instance.currentUser!.uid; // get current user uid DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get(); return userDoc; }

  String uid = FirebaseAuth.instance.currentUser!.uid;
  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get();

  return userDoc;
}

Future<String?> showPasswordPrompt(BuildContext context) async {
  //function to return password entered by user in dialog (for reauthentication before email change)
  final controller = TextEditingController();
  bool isLoading = false;

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirm password'),
            content: TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);
                        Navigator.pop(context, controller.text);
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Confirm'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool> changeEmail(
  // fucntion to change email with reauthentication (returns success status as bool)
  BuildContext context,
  String newEmail,
  String password,
  //takes in context, new email and password for reauthentication
) async {
  final user = FirebaseAuth.instance.currentUser; // get current user

  if (user == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('No user is currently signed in.')));
    return false; // if no user signed in, show error message and return false
  }

  if (newEmail == user.email) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('The new email is the same as the current email.'),
      ),
    );
    return false; // if new email is same as current, show error message and return false
  }

  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(newEmail)) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid email address.')),
    );
    return false;
  }

  if (password.isEmpty) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Password cannot be empty.')));
    return false;
  }

  if (newEmail.length > 320) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email address cannot exceed 320 characters.'),
      ),
    );
    return false;
  }

  if (password.length < 6) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password must be at least 6 characters.')),
    );
    return false;
  }

  if (password.length > 128) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password cannot exceed 128 characters.')),
    );
    return false;
  }

  final credential = EmailAuthProvider.credential(
    // create email auth credential (with current email and provided password)
    email: user.email!,
    password: password,
  );
  try {
    await user.reauthenticateWithCredential(credential); // reauthenticate user
    await user.verifyBeforeUpdateEmail(
      newEmail,
    ); // if successful, send verification email for new email and update email
    await user.reload(); // reload user to apply changes
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Email change initiated. Please verify your new email address.',
        ),
      ),
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error changing email: ${e.message}')),
    );
    return false;
  }
}

Future<void> updateUserData(
  // function to update user data in firestore (with email change handling)
  BuildContext context,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
  TextEditingController emailController,
  DateTime? dateOfBirth,
  String? oldEmail,
  // takes in context, text controllers for first name, last name, email, date of birth and old email
) async {
  if (emailController.text == oldEmail) {
    // if email unchanged, just update other fields (no reauth needed)
    String uid = FirebaseAuth.instance.currentUser!.uid; // get current user uid

    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      // validate first and last name not empty
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('First name and last name cannot be empty.')),
      );
      return;
    }

    if (firstNameController.text.length > 50 ||
        lastNameController.text.length > 50) {
      // validate name lengths
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'First name and last name cannot exceed 50 characters.',
          ),
        ),
      );
      return;
    }

    if (dateOfBirth != null) {
      final now = DateTime.now();
      if (dateOfBirth.isAfter(now)) {
        // validate date of birth not in future
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Date of birth cannot be in the future.')),
        );
        return;
      }
    }

    if (firstNameController.text.length < 3 ||
        lastNameController.text.length < 3) {
      // validate name lengths
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'First name and last name cannot be less than 3 characters.',
          ),
        ),
      );
      return;
    }

    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        // update user data in firestore (leave out email field)
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'date_of_birth': dateOfBirth != null
            ? Timestamp.fromDate(dateOfBirth)
            : null,
        'updatedAt': Timestamp.now(),
      });
    } on Exception catch (e) {
      // catch any exceptions and show error message
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving changes: $e')));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Changes saved successfully')),
    ); //show success message upon completion
  } else {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      // validate first and last name not empty
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('First name and last name cannot be empty.')),
      );
      return;
    }

    if (firstNameController.text.length > 50 ||
        lastNameController.text.length > 50) {
      // validate name lengths
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'First name and last name cannot exceed 50 characters.',
          ),
        ),
      );
      return;
    }

    if (dateOfBirth != null) {
      final now = DateTime.now();
      if (dateOfBirth.isAfter(now)) {
        // validate date of birth not in future
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Date of birth cannot be in the future.')),
        );
        return;
      }
    }

    if (firstNameController.text.length < 3 ||
        lastNameController.text.length < 3) {
      // validate name lengths
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'First name and last name cannot be less than 3 characters.',
          ),
        ),
      );
      return;
    }

    // if email changed, prompt for password and handle email change
    final password = await showPasswordPrompt(
      context,
    ); // call password prompt dialog (from above)

    if (password == null || password.isEmpty) {
      // if no password entered, cancel email change
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email change cancelled.')));
      return;
    }

    if (password.length < 6 || password.length > 128) {
      // validate password length
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be between 6 and 128 characters.'),
        ),
      );
      return;
    }

    if (!context.mounted) return;
    bool success = await changeEmail(
      context,
      emailController.text,
      password,
    ); // call changeEmail function with new email and password (from above)
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      if (success) {
        // if email change successful, update other user data in firestore (as above but including email field)
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'date_of_birth': dateOfBirth != null
              ? Timestamp.fromDate(dateOfBirth)
              : null,
          'updatedAt': Timestamp.now(),
        });
      } else {
        throw Exception(
          'Email change failed.',
        ); // throw exception if email change failed
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving changes: $e')));
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Changes saved successfully.')));
  }
}

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget(this.context, {super.key, this.size = 96});
  final BuildContext context;
  final double size;

  @override
  Widget build(BuildContext context, {double? size}) {
    return ClipOval(
      child: Image.network(
        //profile image URL with refresh key to prevent caching
        'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
        width: size ?? 96,
        height: size ?? 96,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          //show default profile image while loading or if there is an error (prevents blank space or broken image icon)
          if (loadingProgress == null) return child;
          return Image.asset(
            'assets/images/default_pfp.jpg',
            width: size ?? 96,
            height: size ?? 96,
            fit: BoxFit.cover,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          //show default profile image if there is an error loading the image (prevents broken image icon)
          return Image.asset(
            'assets/images/default_pfp.jpg',
            width: size ?? 96,
            height: size ?? 96,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

Future<void> pickAndUploadImage(BuildContext context) async {
  // function to pick image from gallery, format it as JPG (compressed), and upload it to server (homelab)
  final picker = ImagePicker(); // instantiate image picker
  final pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
  ); // pick image from gallery

  if (pickedFile != null) {
    // if an image was picked
    final bytes = await pickedFile.readAsBytes(); // read image bytes (raw data)

    final image = img.decodeImage(
      bytes,
    ); // decode image using 'image' package (from raw bytes to image object)
    if (image == null) return; // if image decoding fails, return

    final jpgBytes = img.encodeJpg(
      image,
      quality: 90,
    ); // encode image as JPG with 90% quality

    final tempDir = Directory.systemTemp; // get system temporary directory
    final tempFile = File(
      '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg', // create temporary file path with unique name (using current timestamp to avoid overwriting)
    );
    await tempFile.writeAsBytes(jpgBytes); // write JPG bytes to temporary file

    if (!context.mounted) return;
    await _uploadProfilePicture(
      tempFile.path,
      context,
    ); // upload profile picture using helper function (defined below)
  }
}

Future<void> _uploadProfilePicture(
  // helper function to upload profile picture to server (using HTTP POST with multipart/form-data to connect to backend)
  String imagePath,
  BuildContext context,
  //takes in image path (temp file path) and context
) async {
  final idToken = await FirebaseAuth.instance.currentUser!
      .getIdToken(); // get Firebase ID token for authentication

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://stock-tokenrequest.matnlaws.co.uk/uploadProfilePicture'),
  );

  request.headers['Authorization'] =
      'Bearer $idToken'; // set authorization header with ID token

  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      imagePath,
      contentType: MediaType('image', 'jpeg'),
    ), // add image file to request as multipart file (with content type JPEG)
  );

  final response = await request.send();

  if (response.statusCode == 200) {
    // check response status (200 = success)
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture uploaded successfully'),
      ), // show success message
    );
  } else {
    final body = await response.stream.bytesToString();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to upload profile picture: $body'),
      ), // show error message with response body
    );
  }
}

class UserSettingsFields extends StatelessWidget {
  // reusable widget for user settings input fields (like name, email, etc)
  // takes a text controller and field type as parameters, formats them to fit page theme, and returns to caller.
  // used in user_settings_screen.dart
  const UserSettingsFields({
    super.key,
    required this.nameController, // controller for the text field
    required this.fieldType, // type of field (e.g., 'Name', 'Email')
  });

  final TextEditingController nameController;
  final String fieldType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$fieldType:',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),

        SizedBox(height: 8),

        TextField(
          controller: nameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}

Future<DateTime?> pickDate(BuildContext context, DateTime? dateOfBirth) async {
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
    dateOfBirth = selectedDate;
  }
  return dateOfBirth;
}

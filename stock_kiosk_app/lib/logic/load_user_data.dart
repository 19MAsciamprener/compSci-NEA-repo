// material imports
import 'package:flutter/material.dart';
// firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        // update user data in firestore (leave out email field)
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'date_of_birth': dateOfBirth != null
            ? Timestamp.fromDate(dateOfBirth)
            : null,
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

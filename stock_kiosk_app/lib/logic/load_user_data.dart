import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String?> showPasswordPrompt(BuildContext context) async {
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
  BuildContext context,
  String newEmail,
  String password,
) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('No user is currently signed in.')));
    return false;
  }

  final credential = EmailAuthProvider.credential(
    email: user.email!,
    password: password,
  );
  try {
    await user.reauthenticateWithCredential(credential);
    await user.verifyBeforeUpdateEmail(newEmail);
    await user.reload();
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
  BuildContext context,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
  TextEditingController emailController,
  DateTime? dateOfBirth,
  String? oldEmail,
) async {
  if (emailController.text == oldEmail) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'date_of_birth': dateOfBirth != null
            ? Timestamp.fromDate(dateOfBirth)
            : null,
      });
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving changes: $e')));
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Changes saved successfully')));
  } else {
    final password = await showPasswordPrompt(context);

    if (password == null || password.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Email change cancelled.')));
      return;
    }

    if (!context.mounted) return;
    bool success = await changeEmail(context, emailController.text, password);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      if (success) {
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
          'date_of_birth': dateOfBirth != null
              ? Timestamp.fromDate(dateOfBirth)
              : null,
        });
      } else {
        throw Exception('Email change failed.');
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

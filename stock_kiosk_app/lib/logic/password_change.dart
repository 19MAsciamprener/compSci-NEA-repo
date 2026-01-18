import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_kiosk_app/pages/global/standby_page.dart';

Future<void> updatePassword(
  BuildContext context,
  TextEditingController oldPasswordController,
  TextEditingController newPasswordController,
  TextEditingController newPasswordControllerConfirm,
) async {
  final oldPassword = oldPasswordController.text;
  final newPassword = newPasswordController.text;
  final newPasswordConfirm = newPasswordControllerConfirm.text;

  if (newPassword != newPasswordConfirm) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('New passwords do not match')));
    return;
  }

  if (newPassword.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New password must be at least 6 characters')),
    );
    return;
  }

  if (oldPassword.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please enter your old password')));
    return;
  }

  if (newPassword == oldPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New password must be different from old password'),
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldPassword,
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error reauthenticating: ${e.message}')),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Password updated successfully')));
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => StandbyPage()),
      (route) => false,
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating password: ${e.message}')),
    );
    return;
  }
}

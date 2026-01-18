// material imports
import 'package:flutter/material.dart';
// firebase imports
import 'package:firebase_auth/firebase_auth.dart';
// page imports
import 'package:stock_kiosk_app/pages/global/standby_page.dart';

Future<void> updatePassword(
  //function to update user password with reauthentication and validation
  BuildContext context,
  TextEditingController oldPasswordController,
  TextEditingController newPasswordController,
  TextEditingController newPasswordControllerConfirm,
  //takes in context and text controllers for old password, new password and new password confirmation
) async {
  //instantiate local variables for old password, new password and new password confirmation (from text controllers)
  final oldPassword = oldPasswordController.text;
  final newPassword = newPasswordController.text;
  final newPasswordConfirm = newPasswordControllerConfirm.text;

  if (newPassword != newPasswordConfirm) {
    //check new password matches confirmation
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('New passwords do not match')));
    return;
  }

  if (newPassword.length < 6) {
    //check new password length (firebase minimum is 6, so enforce that here to avoid unecessary firebase calls)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New password must be at least 6 characters')),
    );
    return;
  }

  if (oldPassword.isEmpty) {
    // check old password is not empty
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please enter your old password')));
    return;
  }

  if (newPassword == oldPassword) {
    // check new password is different from old password (to avoid unecessary firebase calls, and for security)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New password must be different from old password'),
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(
      // reauthenticate user with old password
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
    // update password if reauthentication successful
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Password updated successfully')));
    FirebaseAuth.instance
        .signOut(); //sign out user after password change for security
    Navigator.pushAndRemoveUntil(
      //navigate to standby page and remove all previous routes
      context,
      MaterialPageRoute(builder: (context) => StandbyPage()),
      (route) => false,
    );
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating password: ${e.message}')),
    ); // show error message if password update fails
    return;
  }
}

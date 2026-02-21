import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_mobile_app/pages/global/login_page.dart';

Future<void> loginUserWithEmailAndPassword(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Login successful!')));
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
  }
}

void logout(BuildContext context) {
  FirebaseAuth.instance.signOut();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (route) => false,
  );
}

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

  if (newPassword.isEmpty) {
    //check new password is not empty
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please enter a new password')));
    return;
  }

  if (newPasswordConfirm.isEmpty) {
    //check new password confirmation is not empty
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please confirm your new password')));
    return;
  }

  if (newPassword.length > 128) {
    //check new password length (firebase maximum is 128, so enforce that here to avoid unecessary firebase calls)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New password must be less than 128 characters')),
    );
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
    logout(
      context,
    ); // log out user after password change to ensure they reauthenticate with new password (for security)
  } on FirebaseAuthException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating password: ${e.message}')),
    ); // show error message if password update fails
    return;
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendPasswordResetEmail(
  // function to send password reset email to user if they forgot their password
  TextEditingController emailController,
  BuildContext context,
  // takes in email controller and context
) async {
  if (emailController.text.isEmpty) {
    // check email field is not empty
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Please enter your email address')));
    return;
  }

  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(emailController.text.trim())) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid email address.')),
    );
    return;
  }

  if (emailController.text.length > 256) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email address must not exceed 256 characters.'),
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      // send password reset email using trimmed text from email controller (firebase auth method)
      email: emailController.text.trim(),
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset email sent!')),
    ); // show success message
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset failed: ${e.message}'),
      ), // show error message if sending email fails
    );
  }
}

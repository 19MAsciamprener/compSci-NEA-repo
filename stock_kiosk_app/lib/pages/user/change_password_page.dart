// material imports
import 'package:flutter/material.dart';
// internal logic imports
import 'package:stock_kiosk_app/logic/auth/update_password_logic.dart';
import 'package:stock_kiosk_app/widgets/back_button.dart';

class ChangePasswordPage extends StatefulWidget {
  //stateful widget for changing password (fields are cleared after each attempt)
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //all text editing controllers for password fields
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordControllerConfirm =
      TextEditingController();

  @override
  void dispose() {
    // dispose all controllers when the widget is removed from the widget tree (good practice for memory management)
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordControllerConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
        leading: PagePageBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(96.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 96),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 48),
                  Text(
                    'Current Password:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    // field for current password
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 36),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Password:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    // field for new password
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 36),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm New Password:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  SizedBox(height: 8),

                  TextField(
                    // field for confirming new password
                    controller: newPasswordControllerConfirm,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // button to update password (calls function from password_change.dart)
                        updatePassword(
                          context,
                          oldPasswordController,
                          newPasswordController,
                          newPasswordControllerConfirm,
                        );
                      },
                      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        minimumSize: WidgetStateProperty.all(Size(200, 75)),
                      ), //takes theme style from main.dart and customizes size
                      child: Text('Update Password'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

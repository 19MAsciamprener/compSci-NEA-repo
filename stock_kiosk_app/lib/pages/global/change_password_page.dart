import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/logic/password_change.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordControllerConfirm =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
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
                    controller: oldPasswordController,
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
                    controller: newPasswordController,
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
                    controller: newPasswordControllerConfirm,
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
                        updatePassword(
                          context,
                          oldPasswordController,
                          newPasswordController,
                          newPasswordControllerConfirm,
                        );
                      },
                      style: Theme.of(context).elevatedButtonTheme.style
                          ?.copyWith(
                            minimumSize: WidgetStateProperty.all(Size(200, 75)),
                          ),
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

//material imports
import 'package:flutter/material.dart';

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

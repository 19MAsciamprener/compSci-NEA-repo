import 'package:flutter/material.dart';

class UserSettingsFields extends StatelessWidget {
  const UserSettingsFields({
    super.key,
    required this.nameController,
    required this.fieldType,
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

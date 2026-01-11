import 'package:flutter/material.dart';

class NewItemFields extends StatelessWidget {
  const NewItemFields({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 24, color: Colors.white)),
        SizedBox(height: 16),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter $label here',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

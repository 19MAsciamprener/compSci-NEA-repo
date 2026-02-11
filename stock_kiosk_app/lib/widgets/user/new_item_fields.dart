// material imports
import 'package:flutter/material.dart';

class NewItemFields extends StatelessWidget {
  // stateless widget to create reusable text fields for new item entry (item name, quantity, price)
  // used in the new item screen of the app (admin page)
  const NewItemFields({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller; // controller for the text field
  final String label; // label for the text field

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
            hintText:
                'Enter $label here', // hint text for the text field (concatenates the label with "Enter" and "here")
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

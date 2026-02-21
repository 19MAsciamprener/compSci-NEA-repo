import 'package:flutter/material.dart';

class PagePageBackButton extends StatelessWidget {
  const PagePageBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.keyboard_backspace, color: Colors.white, size: 48),
    );
  }
}

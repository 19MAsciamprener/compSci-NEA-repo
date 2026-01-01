import 'package:flutter/material.dart';

class MainIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const MainIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(112, 112),
          maximumSize: const Size(112, 112),
          backgroundColor: Color.fromRGBO(77, 77, 77, 1),
          shape: CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        child: Icon(icon, color: Color(0xFFFFFFFF), size: 48),
      ),
    );
  }
}

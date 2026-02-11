// material imports
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MainIconButton extends StatelessWidget {
  //stateful widget to create a reusable main icon button (gray circular button with an icon in the center)
  // used in the main screen of the app (standby page of app)
  final IconData icon;
  final VoidCallback onPressed;

  const MainIconButton({
    super.key,
    required this.icon, // required parameter for the icon to display in the button
    required this.onPressed, // required parameter for onPressed callback (function to execute on button press)
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          //give custom styles to the button (not coming from theme in main.dart)
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

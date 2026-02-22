import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget(this.context, {super.key, this.size = 96});
  final BuildContext context;
  final double size;

  @override
  Widget build(BuildContext context, {double? size}) {
    return ClipOval(
      child: Image.network(
        //profile image URL with refresh key to prevent caching
        'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
        width: size ?? 96,
        height: size ?? 96,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          //show default profile image while loading or if there is an error (prevents blank space or broken image icon)
          if (loadingProgress == null) return child;
          return Image.asset(
            'assets/images/default_pfp.jpg',
            width: size ?? 96,
            height: size ?? 96,
            fit: BoxFit.cover,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          //show default profile image if there is an error loading the image (prevents broken image icon)
          return Image.asset(
            'assets/images/default_pfp.jpg',
            width: size ?? 96,
            height: size ?? 96,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

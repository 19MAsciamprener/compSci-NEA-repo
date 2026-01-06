import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:stock_kiosk_app/pages/user_settings_page.dart';

import 'package:stock_kiosk_app/pages/standby_page.dart';

class UserAccountPage extends StatefulWidget {
  const UserAccountPage({super.key});

  @override
  State<UserAccountPage> createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  Future<void> _uploadProfilePicture(String imagePath) async {
    final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://stock-tokenrequest.matnlaws.co.uk/uploadProfilePicture',
      ),
    );

    request.headers['Authorization'] = 'Bearer $idToken';

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture uploaded successfully')),
      );
      setState(() {});
    } else {
      final body = await response.stream.bytesToString();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile picture: $body')),
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      final image = img.decodeImage(bytes);
      if (image == null) return;

      final jpgBytes = img.encodeJpg(image, quality: 90);

      final tempDir = Directory.systemTemp;
      final tempFile = File(
        '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(jpgBytes);

      await _uploadProfilePicture(tempFile.path);
    }
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserSettingsPage()),
        );
        break;
      case 'logout':
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StandbyPage()),
          (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        title: const Text(
          'Account Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 48),
            onSelected: (value) {
              _handleMenuSelection(context, value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile settings',
                child: Text('Profile Settings'),
              ),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 256,
              height: 256,
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                  placeholder: 'lib/assets/images/Default_pfp.jpg',
                  image:
                      'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
                  fit: BoxFit.cover,
                  width: 96,
                  height: 96,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _pickAndUploadImage,
              child: const Text('Upload Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}

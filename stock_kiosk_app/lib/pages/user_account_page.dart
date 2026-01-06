import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 256,
              height: 256,
              child: Image.network(
                'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
                cacheWidth: 256,
                fit: BoxFit.cover,

                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Image.asset(
                    'lib/assets/images/Default_pfp.jpg',
                    fit: BoxFit.cover,
                  );
                },

                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'lib/assets/images/Default_pfp.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );

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
              },
              child: const Text('Upload Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}

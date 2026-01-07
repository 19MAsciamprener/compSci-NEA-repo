import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

Future<void> pickAndUploadImage(BuildContext context) async {
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

    if (!context.mounted) return;
    await _uploadProfilePicture(tempFile.path, context);
  }
}

Future<void> _uploadProfilePicture(
  String imagePath,
  BuildContext context,
) async {
  final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://stock-tokenrequest.matnlaws.co.uk/uploadProfilePicture'),
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
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture uploaded successfully')),
    );
  } else {
    final body = await response.stream.bytesToString();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to upload profile picture: $body')),
    );
  }
}

//material imports
import 'package:flutter/material.dart';
// dart imports
import 'dart:io';
//firebase imports
import 'package:firebase_auth/firebase_auth.dart';
//external package imports
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

Future<void> pickAndUploadImage(BuildContext context) async {
  // function to pick image from gallery, format it as JPG (compressed), and upload it to server (homelab)
  final picker = ImagePicker(); // instantiate image picker
  final pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
  ); // pick image from gallery

  if (pickedFile != null) {
    // if an image was picked
    final bytes = await pickedFile.readAsBytes(); // read image bytes (raw data)

    final image = img.decodeImage(
      bytes,
    ); // decode image using 'image' package (from raw bytes to image object)
    if (image == null) return; // if image decoding fails, return

    final jpgBytes = img.encodeJpg(
      image,
      quality: 90,
    ); // encode image as JPG with 90% quality

    final tempDir = Directory.systemTemp; // get system temporary directory
    final tempFile = File(
      '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg', // create temporary file path with unique name (using current timestamp to avoid overwriting)
    );
    await tempFile.writeAsBytes(jpgBytes); // write JPG bytes to temporary file

    if (!context.mounted) return;
    await _uploadProfilePicture(
      tempFile.path,
      context,
    ); // upload profile picture using helper function (defined below)
  }
}

Future<void> _uploadProfilePicture(
  // helper function to upload profile picture to server (using HTTP POST with multipart/form-data to connect to backend)
  String imagePath,
  BuildContext context,
  //takes in image path (temp file path) and context
) async {
  final idToken = await FirebaseAuth.instance.currentUser!
      .getIdToken(); // get Firebase ID token for authentication

  final request = http.MultipartRequest(
    'POST',
    Uri.parse('https://stock-tokenrequest.matnlaws.co.uk/uploadProfilePicture'),
  );

  request.headers['Authorization'] =
      'Bearer $idToken'; // set authorization header with ID token

  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      imagePath,
      contentType: MediaType('image', 'jpeg'),
    ), // add image file to request as multipart file (with content type JPEG)
  );

  final response = await request.send();

  if (response.statusCode == 200) {
    // check response status (200 = success)
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture uploaded successfully'),
      ), // show success message
    );
  } else {
    final body = await response.stream.bytesToString();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to upload profile picture: $body'),
      ), // show error message with response body
    );
  }
}

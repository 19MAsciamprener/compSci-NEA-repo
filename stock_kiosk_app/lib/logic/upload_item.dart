import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> uploadItemToDatabase(
  BuildContext context,
  TextEditingController barcodeController,
  TextEditingController nameController,
  TextEditingController priceController,
  TextEditingController changeController,
  TextEditingController highController,
  TextEditingController lowController,
  TextEditingController mvController,
) async {
  if (barcodeController.text.trim().isEmpty ||
      nameController.text.trim().isEmpty ||
      priceController.text.trim().isEmpty ||
      changeController.text.trim().isEmpty ||
      highController.text.trim().isEmpty ||
      lowController.text.trim().isEmpty ||
      mvController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all fields before saving.')),
    );
    return;
  }

  try {
    final itemDoc = await FirebaseFirestore.instance
        .collection('items')
        .doc(barcodeController.text.trim())
        .get();

    if (itemDoc.exists) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item with this barcode already exists.')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('items')
        .doc(barcodeController.text.trim())
        .set({
          'name': nameController.text.trim(),
          'price': priceController.text.trim(),
          'change': changeController.text.trim(),
          'high': highController.text.trim(),
          'low': lowController.text.trim(),
          'mv': mvController.text.trim(),
        });
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Item added successfully!')));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error uploading Item: $e')));
  }
}

// material imports
import 'package:flutter/material.dart';
// firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadItemToDatabase(
  // function to upload new item to Firestore database (for admin use)
  BuildContext context,
  TextEditingController barcodeController,
  TextEditingController nameController,
  TextEditingController priceController,
  TextEditingController changeController,
  TextEditingController highController,
  TextEditingController lowController,
  TextEditingController mvController,
  // takes in context and text controllers for all item details (from add item page input fields)
) async {
  if (barcodeController.text.trim().isEmpty ||
      nameController.text.trim().isEmpty ||
      priceController.text.trim().isEmpty ||
      changeController.text.trim().isEmpty ||
      highController.text.trim().isEmpty ||
      lowController.text.trim().isEmpty ||
      mvController.text.trim().isEmpty) {
    // check all fields are filled
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please fill in all fields before saving.'),
      ), //if any field is empty, show error
    );
    return;
  }

  if ((mvController.text.trim() != '-') ||
      (mvController.text.trim() != 'v') ||
      (mvController.text.trim() != '^')) {
    // check market value field is valid
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Market Value must be '-', 'v', or '^'.",
        ), //if invalid, show error
      ),
    );
    return;
  }

  if (double.tryParse(highController.text.trim())! <
      double.tryParse(lowController.text.trim())!) {
    // check high price is not less than low price
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("High price cannot be less than Low price."),
      ), //if invalid, show error
    );
    return;
  }

  if (double.tryParse(priceController.text.trim())! >
      double.tryParse(highController.text.trim())!) {
    // check price is not greater than high price
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Price cannot be greater than High price."),
      ), //if invalid, show error
    );
    return;
  }

  if (double.tryParse(priceController.text.trim())! <
      double.tryParse(lowController.text.trim())!) {
    // check price is not less than low price
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Price cannot be less than Low price."),
      ), //if invalid, show error
    );
    return;
  }

  try {
    // try to upload item to Firestore if all fields are filled
    final itemDoc = await FirebaseFirestore.instance
        .collection('items')
        .doc(barcodeController.text.trim())
        .get();

    if (itemDoc.exists) {
      // check if item with this barcode already exists
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item with this barcode already exists.')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('items')
        .doc(barcodeController.text.trim()) // name document by barcode
        .set({
          'name': nameController.text.trim(),
          'price': priceController.text.trim(),
          'change': changeController.text.trim(),
          'high': highController.text.trim(),
          'low': lowController.text.trim(),
          'mv': mvController.text.trim(),
        }); //set item data in Firestore (key: value pairs)
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item added successfully!')),
    ); //show success message upon completion
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error uploading Item: $e')),
    ); //show error message if upload fails
  }
}

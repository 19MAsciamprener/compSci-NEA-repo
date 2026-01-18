// material imports
import 'package:flutter/material.dart';
// internal logic and widget imports
import 'package:stock_kiosk_app/widgets/new_item_fields.dart';
import 'package:stock_kiosk_app/logic/upload_item.dart';

class NewItemPage extends StatefulWidget {
  //stateful widget for adding a new item (fields refresh after each upload)
  const NewItemPage({super.key});

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  //all text editing controllers for new item fields
  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final changeController = TextEditingController();
  final highController = TextEditingController();
  final lowController = TextEditingController();
  final mvController = TextEditingController();

  @override
  void dispose() {
    // dispose all controllers when the widget is removed from the widget tree (good practice for memory management)
    barcodeController.dispose();
    nameController.dispose();
    priceController.dispose();
    changeController.dispose();
    highController.dispose();
    lowController.dispose();
    mvController.dispose();
    super.dispose();
  }

  void clearAllFields() {
    // function to clear all text fields after uploading an item
    barcodeController.clear();
    nameController.clear();
    priceController.clear();
    changeController.clear();
    highController.clear();
    lowController.clear();
    mvController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Item')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //all children widgets come from new_item_fields.dart
              NewItemFields(controller: barcodeController, label: 'barcode'),
              SizedBox(height: 32),
              NewItemFields(controller: nameController, label: 'name'),
              SizedBox(height: 32),
              NewItemFields(controller: priceController, label: 'price'),
              SizedBox(height: 32),
              NewItemFields(controller: changeController, label: 'change'),
              SizedBox(height: 32),
              NewItemFields(controller: highController, label: 'high'),
              SizedBox(height: 32),
              NewItemFields(controller: lowController, label: 'low'),
              SizedBox(height: 32),
              NewItemFields(controller: mvController, label: 'mv.'),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: () async {
                  // upload item to database and clear fields on button press (requests function from upload_item.dart)
                  await uploadItemToDatabase(
                    context,
                    barcodeController,
                    nameController,
                    priceController,
                    changeController,
                    highController,
                    lowController,
                    mvController,
                  );
                  clearAllFields(); // clear all fields after upload
                },
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  //takes theme style from main.dart and customizes size
                  minimumSize: WidgetStateProperty.all(Size(200, 80)),
                ),
                child: Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

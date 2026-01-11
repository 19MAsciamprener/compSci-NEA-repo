// material import
import 'package:flutter/material.dart';
//external package imports
import 'package:mobile_scanner/mobile_scanner.dart';
//firebase imports
import 'package:cloud_firestore/cloud_firestore.dart';
//internal page imports
import 'package:stock_kiosk_app/pages/global/password_login_page.dart';
//internal logic imports
import 'package:stock_kiosk_app/logic/sign_in_logic.dart';

class QrLoginPage extends StatefulWidget {
  //stateful page because of scanner
  const QrLoginPage({super.key});

  @override
  State<QrLoginPage> createState() => _QrLoginPageState();
}

class _QrLoginPageState extends State<QrLoginPage> {
  final MobileScannerController controller = MobileScannerController(
    //controller settings for the scanner
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool scanned =
      false; //to prevent multiple scans, the page is initialised as not scanned
  String? idToken; //variable to hold the scanned token

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Scan QR Code to Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        // stack to overlay scanner and UI elements (as scanner takes full screen)
        children: [
          MobileScanner(
            //scanner widget
            controller: controller,
            onDetect: (capture) async {
              if (scanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                idToken = barcode.rawValue
                    ?.trim(); //get the scanned token, remove whitespace
                if (idToken != null) {
                  // if a token was scanned, set scanned to true to prevent further scans
                  scanned = true;
                  break;
                }
              }
              {
                final backendTokenDoc = await FirebaseFirestore
                    .instance //access Firestore, look for the scanned token
                    .collection('LoginTokens')
                    .doc(idToken)
                    .get();

                if (!backendTokenDoc.exists) {
                  //if the token does not exist in the database, show error
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid QR code scanned.')),
                  );
                  return;
                }

                final docData = backendTokenDoc.data()!; //get the document data
                final expiresAt = (docData['timestamp'] as Timestamp)
                    .toDate()
                    .add(Duration(minutes: 5));

                if (DateTime.now().isAfter(expiresAt)) {
                  //compare current time to expiry time, show error if expired
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('This QR code has expired.')),
                  );
                  return;
                }
                if (!context.mounted) return;
                await kioskSignInWithUid(
                  idToken!,
                  context,
                ); //call sign-in logic with the scanned token if all checks passed
              }
            },
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
          ), // overlay to darken the screen behind the scanner box
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 600,
                  height: 750,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: MobileScanner(controller: controller),
                ),
              ),
            ),
          ),

          Positioned(
            // button to navigate to password login page
            top: 1000,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Unable to scan your QR code?',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),

                ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    minimumSize: WidgetStateProperty.all(Size(200, 80)),
                  ),
                  onPressed: () {
                    // navigate to password login page (allows user to go back)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordLoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Login with Password',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

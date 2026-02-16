// material import
import 'package:flutter/material.dart';
//external package imports
import 'package:mobile_scanner/mobile_scanner.dart';
//internal page imports
import 'package:stock_kiosk_app/pages/global/password_login_page.dart';
//internal logic imports
import 'package:stock_kiosk_app/logic/auth/sign_in_logic.dart';

class QrLoginPage extends StatefulWidget {
  //stateful page because of scanner
  const QrLoginPage({super.key});

  @override
  State<QrLoginPage> createState() => _QrLoginPageState();
}

class _QrLoginPageState extends State<QrLoginPage> {
  bool scanned =
      false; //to prevent multiple scans, the page is initialised as not scanned (will change when a code is scanned)
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
            onDetect: (capture) => onQrScanned(
              context,
              capture,
              scanned,
              idToken,
            ), //calls function from sign_in_logic.dart
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
                  child: MobileScanner(
                    controller: MobileScannerController(
                      detectionSpeed: DetectionSpeed.normal,
                      detectionTimeoutMs: 1250,
                    ),
                  ),
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
                    Navigator.pushReplacement(
                      // navigate to password login page (allows user to go back, but also disposes of the scanner to free up resources)
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

// material import
import 'package:flutter/material.dart';
//dart imports
import 'dart:async';
//external package imports
import 'package:url_launcher/url_launcher.dart';
//internal widget imports
import 'package:stock_kiosk_app/widgets/main_icon_button.dart';
import 'package:stock_kiosk_app/widgets/stock/stock_list_widgets.dart';
//internal page imports
import 'qr_login_page.dart';
import 'settings_page.dart';
import 'stock_price_page.dart';

class StandbyPage extends StatefulWidget {
  //stateful page so that clock can update
  const StandbyPage({super.key});

  @override
  State<StandbyPage> createState() => _StandbyPageState();
}

class _StandbyPageState extends State<StandbyPage> {
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    //initialize timer to update time every 30 seconds
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 30), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                //gesture detector to make whole stock container tappable
                onTap: () {
                  Navigator.push(
                    //navigate to full stock price page on tap (allows user to return to standby page)
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockPricePage(),
                    ), // TODO: MAKE STOCK PRICE PAGE
                  );
                },
                child: StockListBox(
                  now: _now,
                ), //stock list container (shows current stock prices and time)
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar widget
        height: 275,
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              //login button in bottom left corner
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrLoginPage(),
                  ), //navigate to QR login page (allows user to return to standby page)
                );
              },
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                //uses theme data from main.dart
                minimumSize: WidgetStateProperty.all(Size(250, 300)),
              ),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Column(
              //settings, help, and language buttons in bottom right corner
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MainIconButton(
                  icon: Icons.settings,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //navigate to settings page on tap (allows user to return to standby page)
                        builder: (context) => SettingsPage(),
                      ), //TODO: MAKE SETTINGS PAGE
                    );
                  },
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MainIconButton(
                      icon: Icons.help_outline,
                      onPressed: () {
                        launchUrl(
                          Uri.parse('https://www.example.com/help'),
                          mode: LaunchMode
                              .inAppWebView, //opens help page in in-app webview (prevents user from leaving app)
                        );
                      },
                    ), //TODO: MAKE THIS AN IN-APP WEBVIEW

                    MainIconButton(
                      //language selection button
                      icon: Icons.translate,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Select Language'),
                              content: Text(
                                'Language selection dialog content goes here.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ), // TODO: MAKE THIS CHANGE APP LANGUAGE
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

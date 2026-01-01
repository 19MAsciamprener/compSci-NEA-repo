import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/pages/qr_login_page.dart';
import 'package:stock_kiosk_app/widgets/stock_list_items.dart';
import 'package:stock_kiosk_app/widgets/main_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings_page.dart';
import 'stock_price_page.dart';

class StandbyPage extends StatelessWidget {
  const StandbyPage({super.key});

  String _formatTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StockPricePage()),
                  );
                }, // THIS WILL TAKE ME TO THE FULL STOCK PAGE
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stock Prices',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            _formatTime(now),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StockListItems(title: 'Name'),
                          StockListItems(title: 'Price'),
                          StockListItems(title: 'Change'),

                          SizedBox(width: 48),

                          StockListItems(title: 'High'),
                          StockListItems(title: 'Low'),
                          StockListItems(title: 'MV.'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 275,
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QrLoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 300),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MainIconButton(
                  icon: Icons.settings,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ), // THIS WILL TAKE ME TO SETTINGS PAGE

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MainIconButton(
                      icon: Icons.help_outline,
                      onPressed: () {
                        launchUrl(
                          Uri.parse('https://www.example.com/help'),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ), // THIS WILL TAKE ME TO HELP PAGE (WEB)

                    MainIconButton(
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
                    ), // THIS WILL TAKE ME TO LANGUAGE SELECTION DIALOG
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

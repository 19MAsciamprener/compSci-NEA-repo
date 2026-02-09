// TO BE IMPLEMENTED [MATTIA YOU STUPID FUCKING IDIOT GET A MOVE ON WITH YOUR LIFE JESUS CHRIST]

// material imports
import 'package:flutter/material.dart';
//firebase imports
import 'package:firebase_auth/firebase_auth.dart';
//page imports
import 'package:stock_kiosk_app/pages/user/user_account_page.dart';
import 'package:stock_kiosk_app/pages/global/standby_page.dart';
import 'package:stock_kiosk_app/pages/global/stock_price_page.dart';
//widget imports
import 'package:stock_kiosk_app/widgets/table_cell_widgets.dart';
import 'package:stock_kiosk_app/widgets/stock_table_body.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 96,
        title: const Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                // tap profile picture to go to account page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserAccountPage()),
                );
              },
              child: ClipOval(
                child: Image.network(
                  //profile image URL with refresh key to prevent caching
                  'https://stock-tokenrequest.matnlaws.co.uk/images/profile/${FirebaseAuth.instance.currentUser!.uid}.jpg?${DateTime.now().millisecondsSinceEpoch}',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    //show default profile image while loading or if there is an error (prevents blank space or broken image icon)
                    if (loadingProgress == null) return child;
                    return Image.asset(
                      'lib/assets/images/default_pfp.jpg',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    //show default profile image if there is an error loading the image (prevents broken image icon)
                    return Image.asset(
                      'lib/assets/images/default_pfp.jpg',
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                //gesture detector to make whole stock container tappable
                onTap: () {
                  Navigator.push(
                    //navigate to full stock price page on tap (allows user to return to standby page)
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockPricePage(),
                    ), // FUTURE JOB: MAKE STOCK PRICE PAGE
                  );
                },
                child: Container(
                  width: 450,
                  height: 380,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    //takes theme data from main.dart
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Stock Prices', //title of container
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      const SizedBox(height: 32.0),

                      Column(
                        children: [
                          // Header row of stock table
                          Row(
                            children: [
                              headerCell(
                                'Name',
                                flex: 3,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              headerCell(
                                'Price',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              headerCell(
                                'Change',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            height: 180, //fixed height for stock table
                            child: miniStockTable(), //stock table body widget
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Placeholder(),
                    SizedBox(width: 16.0),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 200,
                      height: double.infinity,
                      child: Placeholder(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

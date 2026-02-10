// TO BE IMPLEMENTED [MATTIA YOU STUPID FUCKING IDIOT GET A MOVE ON WITH YOUR LIFE JESUS CHRIST]

// material imports
import 'package:flutter/material.dart';
//page imports
import 'package:stock_kiosk_app/pages/user/user_account_page.dart';
import 'package:stock_kiosk_app/pages/global/stock_price_page.dart';
import 'package:stock_kiosk_app/pages/user/user_purchase_page.dart';
import 'package:stock_kiosk_app/widgets/home_page_widgets.dart';
import 'package:stock_kiosk_app/widgets/stock_list_widgets.dart';
//widget imports
import 'package:stock_kiosk_app/widgets/profile_picture_widget.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});
  //TODO: MAKE THIS DYNAMIC

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
              child: ProfilePictureWidget(context, size: 96),
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
                    ), // TODO: MAKE STOCK PRICE PAGE
                  );
                },
                child: MiniStockListBox(),
              ),
              const SizedBox(height: 16.0),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: CategoryCards()),

                    SizedBox(width: 16.0),

                    SizedBox(
                      width: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: 700,
                            child: Column(
                              children: [
                                Text(
                                  'Current Items',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Location: Warehouse 1',
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ),
                                SizedBox(height: 18),
                                Expanded(child: CartItemList()),
                                Divider(),

                                Text(
                                  'Total:', // TODO: MAKE DYNAMIC
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),

                                Text(
                                  '\$123.45', // TODO: MAKE DYNAMIC
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),

                                SizedBox(height: 18),

                                ElevatedButton(
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                        textStyle: WidgetStatePropertyAll(
                                          TextStyle(fontSize: 24),
                                        ),
                                      ), // make purchase button smaller than category buttons
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserPurchasePage(),
                                      ),
                                    );
                                  },
                                  child: Text('Purchase'), // TODO: MAKE DYNAMIC
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

// TO BE IMPLEMENTED [MATTIA YOU STUPID FUCKING IDIOT GET A MOVE ON WITH YOUR LIFE JESUS CHRIST]

// material imports
import 'package:flutter/material.dart';
//page imports
import 'package:stock_kiosk_app/pages/user/user_account_page.dart';
import 'package:stock_kiosk_app/pages/global/stock_price_page.dart';
import 'package:stock_kiosk_app/widgets/user/cart_pane_widget.dart';
//widget imports
import 'package:stock_kiosk_app/widgets/user/profile_picture_widget.dart';
import 'package:stock_kiosk_app/widgets/user/home_page_widgets.dart';
import 'package:stock_kiosk_app/widgets/stock/stock_list_widgets.dart';

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

                    CartPaneWidget(),
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

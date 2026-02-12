import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/main.dart';
import 'package:stock_kiosk_app/pages/user/user_purchase_page.dart';
import 'package:stock_kiosk_app/widgets/home_page_widgets.dart';

class CartPaneWidget extends StatelessWidget {
  const CartPaneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    MyApp.kioskLocation,
                    textAlign: TextAlign.end,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ),
                SizedBox(height: 18),
                Expanded(child: CartItemList()),
                Divider(),

                Text(
                  'Total:', // TODO: MAKE DYNAMIC
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                Text(
                  '\$123.45', // TODO: MAKE DYNAMIC
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                SizedBox(height: 18),

                ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 24)),
                  ), // make purchase button smaller than category buttons
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPurchasePage(),
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
    );
  }
}

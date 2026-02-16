import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_kiosk_app/logic/provider/cart_provider.dart';
import 'package:stock_kiosk_app/main.dart';
import 'package:stock_kiosk_app/pages/user/user_purchase_page.dart';

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

                Text('Total:', style: Theme.of(context).textTheme.titleMedium),

                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return Text(
                      '\$ ${cartProvider.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    );
                  },
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
                  child: Text('Purchase'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;
    return ListView.builder(
      itemCount: cart.length,
      itemBuilder: (context, index) {
        final cartItem = cart[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: GestureDetector(
            onTap: () {
              _showRemoveDialog(context, cartItem);
            },
            child: Column(
              children: [
                Text(
                  cartItem['title'] ?? 'Unknown Item',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Cost: ${cartItem['price']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showRemoveDialog(BuildContext context, Map<String, dynamic> item) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        title: const Text('Remove item'),
        content: Text('Remove "${item['title']}" from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Provider.of<CartProvider>(
                context,
                listen: false,
              ).removeFromCart(item);
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      );
    },
  );
}

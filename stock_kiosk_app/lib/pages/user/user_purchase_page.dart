// TODO: NEEDS TO BE COMMENTED

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_kiosk_app/logic/account_transaction_logic.dart';
import 'package:stock_kiosk_app/logic/provider/cart_provider.dart';

class UserPurchasePage extends StatelessWidget {
  const UserPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final grouped = cartProvider.itemsByCategory;

    if (grouped.isEmpty) {
      return const Center(child: Text("Cart is empty"));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Purchase Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;
          final total = cartProvider.totalForCategory(category);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Category Title
              Text(
                "$category Coins",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),

              /// Items in this category
              ...items.map(
                (item) => ListTile(
                  title: Text(
                    item['title'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    "\$${item['price']}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              /// Category total
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total: \$${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const Divider(thickness: 2),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}


// Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   try {
//                     await purchaseItem(cost: 10, category: 'drink');
//                     if (!context.mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Purchase successful')),
//                     );
//                   } catch (e) {
//                     if (!context.mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Purchase failed: $e')),
//                     );
//                   }
//                 },
//                 child: Text('Test Purchase'),
//               ),
//             ),
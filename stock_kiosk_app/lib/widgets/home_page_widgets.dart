import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_kiosk_app/logic/provider/cart_provider.dart';
import 'package:stock_kiosk_app/pages/user/user_category_subpage.dart';

class CategoryCards extends StatelessWidget {
  const CategoryCards({super.key});
  static final List<String> categories = [
    'Drinks',
    'Snacks',
    'Books',
    'Stationery',
    'Electronics',
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserCategorySubpage(category: category),
              ),
            );
          },
          child: Card(
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                category,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        );
      },
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
        );
      },
    );
  }
}

class ItemCards extends StatelessWidget {
  const ItemCards({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('items')
        .where('category', isEqualTo: category);

    return StreamBuilder(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No items found in this category.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            return GestureDetector(
              onTap: () {
                Provider.of<CartProvider>(context, listen: false).addToCart({
                  'id': doc.id,
                  'title': doc['name'],
                  'price': doc['price'],
                });
              },
              child: Card(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        doc['name'],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '\$${doc['price']}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  static final List<String> cartItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length, // TODO: MAKE DYNAMIC
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            children: [
              Text(
                cartItems[index].toString(), // TODO: MAKE DYNAMIC
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              Text(
                'Quantity: 1', // TODO: MAKE DYNAMIC
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
          return const Center(child: Text('No items found in this category.'));
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
                //TODO: ADD TO CART FUNCTIONALITY
              },
              child: Card(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text(
                    doc['name'],
                    style: Theme.of(context).textTheme.titleLarge,
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

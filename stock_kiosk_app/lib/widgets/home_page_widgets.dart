import 'package:flutter/material.dart';

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
    return Expanded(
      child: GridView.builder(
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
              //TODO: NAVIGATE TO CATEGORY PAGE
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
      ),
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
    return Expanded(
      child: ListView.builder(
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
      ),
    );
  }
}

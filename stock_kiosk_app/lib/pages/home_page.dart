import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/widgets/stock_list_items.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}

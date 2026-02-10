import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/widgets/stock_table_body.dart';
import 'package:stock_kiosk_app/widgets/table_cell_widgets.dart';

String _formatTime(DateTime dt) {
  //will format time as HH:MM
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(dt.hour)}:${two(dt.minute)}';
}

class StockListBox extends StatelessWidget {
  const StockListBox({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        //takes theme data from main.dart
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stock Prices', //title of container
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                _formatTime(now), //current time on right (formatted as HH:MM)
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: 32.0),

          Column(
            children: [
              // Header row of stock table
              Row(
                children: [
                  headerCell('Name', flex: 3),
                  headerCell('Price'),
                  headerCell('Change'),
                  const SizedBox(width: 48),
                  headerCell('High'),
                  headerCell('Low'),
                  headerCell('MV'),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 612, //fixed height for stock table
                child: stockTable(), //stock table body widget
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MiniStockListBox extends StatelessWidget {
  const MiniStockListBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 380,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
    );
  }
}

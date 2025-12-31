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
      bottomNavigationBar: BottomAppBar(
        height: 250,
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 250),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16),
            Column(children: [
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 120),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Icon(Icons.add,color: Color(0xFFFFFFFF), size: 48,)),
            
            Row(children: [ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 120),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Icon(Icons.mail,color: Color(0xFFFFFFFF), size: 48,)),
            
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 120),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Icon(Icons.settings,color: Color(0xFFFFFFFF), size: 48,)),
            ],)])
          ],
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';

class StockPricePage extends StatelessWidget {
  const StockPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Stock Prices',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Detailed Stock Prices will be shown here.',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

// TO BE IMPLEMENTED

import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/widgets/back_button.dart';

class StockPricePage extends StatelessWidget {
  const StockPricePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PagePageBackButton(),
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

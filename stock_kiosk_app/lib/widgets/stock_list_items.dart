import 'package:flutter/material.dart';
import '../utils/dummy_data.dart';

class StockListItems extends StatelessWidget {
  final String title;

  const StockListItems({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12.0),
          ListView.builder(
            itemCount: itemList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Text(
                textAlign: TextAlign.center,
                itemList[index][title.toLowerCase()].toString(),
                style: TextStyle(color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}

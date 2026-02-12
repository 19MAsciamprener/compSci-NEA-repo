import 'package:flutter/material.dart';

class CoinValues extends StatelessWidget {
  const CoinValues({super.key, required this.coinType});
  final String coinType;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'lib/assets/images/${coinType}_coin.ico',
          width: 128,
          height: 128,
        ),
        SizedBox(width: 48),
        Text(
          //display coin value based on coin type (1 for drink, 2 for food)
          coinType == 'drink' ? '1 Token' : '2 Tokens',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CoinList extends StatelessWidget {
  const CoinList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CoinValues(
          coinType: 'drink',
        ), //custom widget to display coin values (image and text based on coin type)

        SizedBox(height: 24),
        CoinValues(
          coinType: 'food',
        ), //custom widget to display coin values (image and text based on coin type)

        SizedBox(height: 24),

        CoinValues(
          coinType: 'library',
        ), //custom widget to display coin values (image and text based on coin type)

        SizedBox(height: 24),

        CoinValues(
          coinType: 'stationery',
        ), //custom widget to display coin values (image and text based on coin type)
      ],
    );
  }
}

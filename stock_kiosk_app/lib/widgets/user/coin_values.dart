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

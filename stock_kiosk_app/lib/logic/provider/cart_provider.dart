import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    cart.remove(product);
    notifyListeners();
  }

  double get totalPrice {
    return cart.fold(0.0, (total, item) {
      final dynamic rawPrice = item['price'];

      double price;

      if (rawPrice is num) {
        price = rawPrice.toDouble();
      } else if (rawPrice is String) {
        price = double.tryParse(rawPrice) ?? 0.0;
      } else {
        price = 0.0;
      }

      return total + price;
    });
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }
}

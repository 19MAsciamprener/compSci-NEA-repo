//material imports
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> cart =
      []; //list of products in cart, each product is a map with keys (name, price, category, etc.)

  void addToCart(Map<String, dynamic> product) {
    cart.add(product); //adds product to cart
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> product) {
    cart.remove(product); //removes product from cart
    notifyListeners();
  }

  double? get totalPrice {
    //calculates total price of items in cart
    return cart.fold(0.0, (total, item) {
      final dynamic rawPrice = item['price'];

      double? price;

      if (rawPrice is num) {
        //handles both int and double types for price
        price = rawPrice.toDouble();
      } else if (rawPrice is String) {
        price = double.tryParse(rawPrice);
      } else {
        price = null;
      }
      if (price == null) {
        return null;
      }

      return total! + (price);
    });
  }

  void clearCart() {
    //empty cart, used after checkout or on logout
    cart.clear();
    notifyListeners();
  }
}

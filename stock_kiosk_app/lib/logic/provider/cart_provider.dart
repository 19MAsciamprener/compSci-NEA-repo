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

  void clearCategory(String category) {
    cart.removeWhere((item) => item['category'] == category);
    notifyListeners();
  }

  //TESTING FOR NOW
  Map<String, List<Map<String, dynamic>>> get itemsByCategory {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in cart) {
      final String category = item['category'] ?? 'Other';

      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }

      grouped[category]!.add(item);
    }

    return grouped;
  }

  // Optional: total price per category
  double totalForCategory(String category) {
    final items = cart.where((item) => item['category'] == category);

    return items.fold(0.0, (total, item) {
      final rawPrice = item['price'];

      if (rawPrice is num) {
        return total + rawPrice.toDouble();
      } else if (rawPrice is String) {
        return total + (double.tryParse(rawPrice) ?? 0.0);
      }
      return total;
    });
  }
}

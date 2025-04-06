import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({
    required this.item,
    this.quantity = 1,
  });

  double get totalPrice => item.price * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0, (sum, cartItem) => sum + cartItem.totalPrice);
  }

  void addItem(MenuItem item) {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.item.id == item.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((cartItem) => cartItem.item.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.item.id == itemId);
    if (existingIndex >= 0) {
      if (newQuantity > 0) {
        _items[existingIndex].quantity = newQuantity;
      } else {
        _items.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }
}
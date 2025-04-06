import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../widgets/cart_item_card.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                return CartItemCard(
                  item: cartItem.item,
                  quantity: cartItem.quantity,
                  onRemove: () {
                    cart.removeItem(cartItem.item.id);
                  },
                  onQuantityChanged: (newQuantity) {
                    cart.updateQuantity(cartItem.item.id, newQuantity);
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: TextStyle(fontSize: 18)),
                    Text('\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to checkout
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text('Proceed to Checkout',
                        style: TextStyle(fontSize: 16)),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
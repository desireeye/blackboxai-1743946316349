import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _paymentMethod;
  bool _isProcessing = false;

  Future<void> _placeOrder(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    if (_paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    
    try {
      // Process payment based on selected method
      if (_paymentMethod == 'COD') {
        // No payment processing needed for COD
      } else {
        final paymentService = PaymentService();
        paymentService.initialize();
        await paymentService.processPayment(
          amount: cart.totalAmount,
          currency: 'INR',
          description: 'Chicago Delight\'s Order',
          context: context,
        );
        paymentService.dispose();
      }

      // Place order in Firestore
      await Provider.of<FirebaseService>(context, listen: false).placeOrder({
        'items': cart.items.map((item) => item.toMap()).toList(),
        'total': cart.totalAmount,
        'paymentMethod': _paymentMethod,
        'status': 'Processing',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear cart
      cart.clearCart();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );

      // Navigate back to menu
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: \$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Select Payment Method:', style: TextStyle(fontSize: 18)),
            ListTile(
              title: Text('Cash on Delivery'),
              leading: Radio<String>(
                value: 'COD',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() => _paymentMethod = value);
                },
              ),
            ),
            ListTile(
              title: Text('UPI'),
              leading: Radio<String>(
                value: 'UPI',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() => _paymentMethod = value);
                },
              ),
            ),
            ListTile(
              title: Text('Credit/Debit Card'),
              leading: Radio<String>(
                value: 'CARD',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() => _paymentMethod = value);
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            _isProcessing
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () => _placeOrder(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Place Order',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 0),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
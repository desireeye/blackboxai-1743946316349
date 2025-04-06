import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;

  void initialize() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  Future<void> processPayment({
    required double amount,
    required String currency,
    required String description,
    required BuildContext context,
  }) async {
    try {
      final options = {
        'key': 'YOUR_RAZORPAY_API_KEY', // Replace with your actual key
        'amount': (amount * 100).toInt(), // Convert to paise
        'name': 'Chicago Delight\'s Pizza & Grillz',
        'description': description,
        'prefill': {
          'contact': '', // Customer phone number
          'email': '', // Customer email
        },
        'theme': {
          'color': '#FF0000', // Chicago Delight's brand color
        }
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Payment Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment processing failed: $e')),
      );
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
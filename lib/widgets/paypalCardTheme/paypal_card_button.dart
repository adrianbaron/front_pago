
import 'package:flutter/material.dart';

import '../../interfaces_abstractas/payment_button.dart';


class PayPalButton implements PaymentButton {
  @override
  Widget render(VoidCallback onPressed, bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'PAGAR CON PAYPAL',
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}

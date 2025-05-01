import 'package:flutter/material.dart';
import 'package:front_pago/factories/interfaces_abstractas/payment_icon.dart';

class CreditCardIcon implements PaymentIcon {
  @override
  Icon render() {
    return const Icon(Icons.credit_card, color: Colors.blue);
  }
}
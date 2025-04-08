import 'package:flutter/material.dart';
import 'package:front_pago/interfaces_abstractas/payment_icon.dart';

class PayPalIcon implements PaymentIcon {
  @override
  Icon render() {
    return const Icon(Icons.account_balance_wallet, color: Colors.indigo);
  }
}
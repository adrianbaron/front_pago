import 'package:flutter/material.dart';
import 'package:front_pago/interfaces_abstractas/payment_icon.dart';

class DebitCardIcon implements PaymentIcon {
  @override
  Icon render() {
    return const Icon(Icons.credit_card_outlined, color: Colors.green);
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:front_pago/interfaces_abstractas/payment_form.dart';
import 'package:front_pago/widgets/paypalCardTheme/paypal_card_button.dart';
import 'package:front_pago/widgets/paypalCardTheme/paypal_card_form.dart';
import 'package:front_pago/widgets/paypalCardTheme/paypal_card_icon.dart';
import 'package:front_pago/interfaces_abstractas/payment_button.dart';

import '../interfaces_abstractas/payment_icon.dart';
import '../interfaces_abstractas/payment_theme_factory.dart';

class PayPalThemeFactory implements PaymentThemeFactory {
  @override
  PaymentButton createButton() => PayPalButton();
  
  @override
  PaymentForm createForm() => PayPalForm();
  
  @override
  PaymentIcon createIcon() => PayPalIcon();
  
  @override
  Color getPrimaryColor() => Colors.indigo;
  
  @override
  String getMethodName() => 'PayPal';
}
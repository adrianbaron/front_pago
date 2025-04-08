import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:front_pago/interfaces_abstractas/payment_form.dart';
import 'package:front_pago/widgets/creditCardTheme/credit_card_button.dart';
import 'package:front_pago/widgets/creditCardTheme/credit_card_icon.dart';
import 'package:front_pago/interfaces_abstractas/payment_button.dart';
import 'package:front_pago/interfaces_abstractas/payment_icon.dart';
import 'package:front_pago/interfaces_abstractas/payment_theme_factory.dart';

import '../widgets/creditCardTheme/credit_card_form.dart';

class CreditCardThemeFactory implements PaymentThemeFactory {
  @override
  PaymentButton createButton() => CreditCardButton();
  
  @override
  PaymentForm createForm() => CreditCardForm();
  
  @override
  PaymentIcon createIcon() => CreditCardIcon();
  
  @override
  Color getPrimaryColor() => Colors.blue;
  
  @override
  String getMethodName() => 'Tarjeta de Crédito';
}

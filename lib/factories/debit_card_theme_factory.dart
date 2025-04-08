
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:front_pago/interfaces_abstractas/payment_form.dart';
import 'package:front_pago/widgets/debitCardTheme/debit_card_form.dart';

import '../interfaces_abstractas/payment_button.dart';
import '../interfaces_abstractas/payment_icon.dart';
import '../interfaces_abstractas/payment_theme_factory.dart';
import '../widgets/debitCardTheme/debit_card_button.dart';
import '../widgets/debitCardTheme/debit_card_icon.dart';

class DebitCardThemeFactory implements PaymentThemeFactory {
  @override
  PaymentButton createButton() => DebitCardButton();
  
  @override
  PaymentForm createForm() => DebitCardForm();
  
  @override
  PaymentIcon createIcon() => DebitCardIcon();
  
  @override
  Color getPrimaryColor() => Colors.green;
  
  @override
  String getMethodName() => 'Tarjeta de Débito';
}
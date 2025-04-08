
import 'dart:ui';

import 'package:front_pago/interfaces_abstractas/payment_button.dart';
import 'package:front_pago/interfaces_abstractas/payment_form.dart';
import 'package:front_pago/interfaces_abstractas/payment_icon.dart';

abstract class PaymentThemeFactory {
  PaymentButton createButton();
  PaymentForm createForm();
  PaymentIcon createIcon();
  Color getPrimaryColor();
  String getMethodName();
}
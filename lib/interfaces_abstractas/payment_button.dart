import 'package:flutter/material.dart';

abstract class PaymentButton {
  Widget render(VoidCallback onPressed, bool isLoading);
}
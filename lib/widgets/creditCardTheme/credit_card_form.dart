// credit_card_form.dart
import 'package:flutter/material.dart';
import 'package:front_pago/interfaces_abstractas/payment_form.dart';


class CreditCardForm implements PaymentForm {
  @override
  Widget render(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalles de la Tarjeta de Crédito',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Monto',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
            hintText: 'Ingrese el monto',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}
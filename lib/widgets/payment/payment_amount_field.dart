import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_pago/provider/payment_provider.dart';
import 'package:front_pago/utils/validators.dart';
import 'package:front_pago/widgets/common/custom_card.dart';
import 'package:front_pago/widgets/common/section_header.dart';
import 'package:provider/provider.dart';

class PaymentAmountField extends StatelessWidget {
  final TextEditingController controller;
  
  const PaymentAmountField({
    Key? key, 
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final primaryColor = paymentProvider.currentPrimaryColor;
    
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      borderColor: primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.monetization_on,
            title: 'Datos de Pago',
            color: primaryColor,
          ),
          const Divider(height: 24),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Monto',
              hintText: '0.00',
              prefixText: '\$ ',
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: Validators.validateAmount,
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:front_pago/provider/payment_provider.dart';
import 'package:front_pago/widgets/common/custom_card.dart';
import 'package:front_pago/widgets/common/section_header.dart';
import 'package:provider/provider.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.payments,
            title: 'Método de Pago',
            color: paymentProvider.currentPrimaryColor,
          ),
          const Divider(height: 24),
          // Selección de método de pago con fábricas
          ...paymentProvider.factories.entries.map((entry) => RadioListTile<String>(
                title: Row(
                  children: [
                    entry.value.createIcon().render(),
                    const SizedBox(width: 8),
                    Text(
                      entry.value.getMethodName(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                value: entry.key,
                groupValue: paymentProvider.selectedPaymentType,
                activeColor: entry.value.getPrimaryColor(),
                onChanged: (value) {
                  if (value != null) {
                    paymentProvider.setPaymentType(value);
                  }
                },
              )),
        ],
      ),
    );
  }
}
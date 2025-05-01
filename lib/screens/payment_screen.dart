import 'package:flutter/material.dart';
import 'package:front_pago/models/payment_request.dart';
import 'package:front_pago/provider/payment_provider.dart';
import 'package:front_pago/widgets/common/loading_button.dart';
import 'package:front_pago/widgets/payment/notification_selector.dart';
import 'package:front_pago/widgets/payment/payment_amount_field.dart';
import 'package:front_pago/widgets/payment/payment_method_selector.dart';
import 'package:front_pago/widgets/payment/payment_result_dialog.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  // Método para procesar el pago
  Future<void> _processPayment(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    
    try {
      // Normalizar el formato del monto
      String normalizedInput = _amountController.text.replaceAll(',', '.');
      double amount = double.parse(normalizedInput);
      
      // Crear la solicitud de pago
      final request = PaymentRequest(
        paymentType: paymentProvider.selectedPaymentType,
        amount: amount,
        notificationType: paymentProvider.selectedNotificationType,
        notificationRecipient: _recipientController.text,
      );
      
      // Procesar el pago
      final response = await paymentProvider.processPayment(request);
      
      if (response != null && context.mounted) {
        // Mostrar diálogo con el resultado
        showDialog(
          context: context,
          builder: (context) => PaymentResultDialog(
            response: response,
            paymentType: paymentProvider.selectedPaymentType,
            notificationType: paymentProvider.selectedNotificationType,
            recipient: _recipientController.text,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final primaryColor = paymentProvider.currentPrimaryColor;
    
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: primaryColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return primaryColor;
            }
            return Colors.grey;
          }),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Procesador de Pagos'),
          elevation: 4,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.grey.shade100,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Selector de método de pago
                    const PaymentMethodSelector(),
                    
                    // Campo de monto
                    PaymentAmountField(controller: _amountController),
                    
                    // Selector de notificación
                    NotificationSelector(recipientController: _recipientController),
                    
                    // Botón de procesar pago
                    LoadingButton(
                      onPressed: () => _processPayment(context),
                      isLoading: paymentProvider.isLoading,
                      text: 'Procesar Pago con ${paymentProvider.currentPaymentMethodName}',
                      icon: Icons.check_circle,
                      backgroundColor: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
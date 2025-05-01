import 'package:flutter/material.dart';
import 'package:front_pago/factories/interfaces_abstractas/payment_theme_factory.dart';
import 'package:front_pago/models/payment_response.dart';
import 'package:front_pago/provider/payment_provider.dart';
import 'package:provider/provider.dart';
import 'package:front_pago/screens/report_configuration_screen.dart'; // Importar la pantalla de configuración

class PaymentResultDialog extends StatelessWidget {
  final PaymentResponse response;
  final String paymentType;
  final String notificationType;
  final String recipient;
  
  const PaymentResultDialog({
    Key? key,
    required this.response,
    required this.paymentType,
    required this.notificationType,
    required this.recipient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final factory = paymentProvider.factories[paymentType]!;
    final primaryColor = factory.getPrimaryColor();
    final notificationIcon = paymentProvider.getNotificationIcon(notificationType);
    
    return AlertDialog(
      title: Text(
        'Pago Procesado',
        style: TextStyle(color: primaryColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Destacar el método de pago
            _buildMethodInfoCard(
              factory, 
              primaryColor
            ),
            const SizedBox(height: 16),
            const Text(
              'Detalles del pago:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Monto original: \$${response.originalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Monto final: \$${response.finalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              'Comisión: \$${response.commission.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            // Destacar el tipo de notificación
            _buildNotificationTypeCard(
              notificationType,
              paymentProvider,
              primaryColor,
              notificationIcon
            ),
            const SizedBox(height: 16),
            
            // Estado de la notificación
            _buildNotificationStatusCard(response),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
          child: const Text('Cerrar'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Primero, cerrar el diálogo
            Navigator.of(context).pop();
            
            // Generar los datos del reporte
            final reportData = response.toReportData(
              paymentType, 
              notificationType, 
              recipient
            );
            
            // Navegar a la pantalla de configuración de reporte
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportConfigurationScreen(
                  paymentData: reportData,
                ),
              ),
            );
          },
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generar Comprobante'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
  
  // Widget para la tarjeta de método de pago
 Widget _buildMethodInfoCard(PaymentThemeFactory factory, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor, width: 1),
      ),
      child: Row(
        children: [
          factory.createIcon().render(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Método de pago:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  factory.getMethodName(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget para la tarjeta de tipo de notificación
  Widget _buildNotificationTypeCard(String notificationType, PaymentProvider provider, Color primaryColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Método de notificación:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  provider.getNotificationName(notificationType),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget para la tarjeta de estado de notificación
  Widget _buildNotificationStatusCard(PaymentResponse response) {
    if (response.notificationSent) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade300, width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado de notificación:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Notificación enviada a: $recipient',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade300, width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado de notificación:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Error: ${response.notificationMessage ?? "Error desconocido"}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
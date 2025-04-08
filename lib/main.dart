import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_pago/factories/credit_card_theme_factory.dart';
import 'package:front_pago/factories/debit_card_theme_factory.dart';
import 'package:front_pago/factories/paypal_card_theme_factory.dart';
import 'package:front_pago/interfaces_abstractas/payment_theme_factory.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Procesador de Pagos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedPaymentType = 'CREDIT_CARD';
  String _selectedNotificationType = 'email';
  bool _isLoading = false;

  // API URL para entorno web
  final String apiUrl = 'http://localhost:8080/api/payments/process';

  final Map<String, PaymentThemeFactory> _factories = {
    'CREDIT_CARD': CreditCardThemeFactory(),
    'DEBIT_CARD': DebitCardThemeFactory(),
    'PAYPAL': PayPalThemeFactory(),
  };

  // Lista de métodos de notificación disponibles
  final Map<String, String> _notificationMethods = {
    'email': 'Correo Electrónico',
    'sms': 'Mensaje SMS',
    'ws': 'Whatsapp',
  };

  // Iconos para los métodos de notificación
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'email':
        return Icons.email;
      case 'sms':
        return Icons.sms;
      case 'ws':
        return Icons.telegram;
      default:
        return Icons.notifications;
    }
  }

  // Validador de correo electrónico
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validador de número de teléfono
  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(phone);
  }

  // Texto de ayuda para el formato del destinatario según el tipo seleccionado
  String _getRecipientHintText() {
    switch (_selectedNotificationType) {
      case 'email':
        return 'ejemplo@correo.com';
      case 'sms':
        return '+573112344322';
      case 'ws':
        return '+573102344564';
      default:
        return 'Destinatario';
    }
  }

  // Validar el destinatario según el tipo de notificación
  String? _validateRecipient(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el destinatario';
    }

    switch (_selectedNotificationType) {
      case 'email':
        if (!_isValidEmail(value)) {
          return 'Por favor ingrese un correo electrónico válido';
        }
        break;
      case 'sms':
      case 'ws':
        if (!_isValidPhone(value)) {
          return 'Por favor ingrese un número de teléfono válido';
        }
        break;
    }
    return null;
  }

  // Validar el monto
  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un monto';
    }

    try {
      // Reemplazar coma por punto para manejar formatos de números locales
      String normalizedInput = value.replaceAll(',', '.');
      double amount = double.parse(normalizedInput);
      if (amount <= 0) {
        return 'El monto debe ser mayor a 0';
      }
    } catch (e) {
      return 'Por favor ingrese un monto válido';
    }
    return null;
  }

  // Obtener el nombre amigable del tipo de notificación
  String _getNotificationName(String type) {
    return _notificationMethods[type] ?? 'Desconocido';
  }

  Future<void> _processPayment() async {
    // Validar el formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Reemplazar coma por punto para manejar formatos de números locales
      String normalizedInput = _amountController.text.replaceAll(',', '.');
      double amount = double.parse(normalizedInput);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode({
          'paymentType': _selectedPaymentType,
          'amount': amount,
          'notificationType': _selectedNotificationType,
          'notificationRecipient': _recipientController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (!context.mounted) return;
        
        // Mostrar resultado en un diálogo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final factory = _factories[_selectedPaymentType]!;
            final primaryColor = factory.getPrimaryColor();
            final notificationIcon = _getNotificationIcon(_selectedNotificationType);
            
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
                    Container(
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
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Detalles del pago:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Monto original: \$${responseData['originalAmount'].toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    Text('Monto final: \$${responseData['finalAmount'].toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    Text(
                      'Comisión: \$${(responseData['finalAmount'] - responseData['originalAmount']).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Destacar el tipo de notificación
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            notificationIcon,
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
                                  _getNotificationName(_selectedNotificationType),
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
                    ),
                    const SizedBox(height: 16),
                    
                    // Estado de la notificación
                    if (responseData['notificationSent'] == true)
                      Container(
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
                                    'Notificación enviada a: ${_recipientController.text}',
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
                      )
                    else
                      Container(
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
                                    'Error: ${responseData['notificationMessage'] ?? "Error desconocido"}',
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
                      ),
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
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode} - ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final factory = _factories[_selectedPaymentType]!;
    final Color primaryColor = factory.getPrimaryColor();
    
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
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
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
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.payments, color: primaryColor),
                                const SizedBox(width: 8),
                                const Text(
                                  'Método de Pago',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            // Selección de método de pago con fábricas
                            ..._factories.entries.map((entry) => RadioListTile<String>(
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
                                  groupValue: _selectedPaymentType,
                                  activeColor: entry.value.getPrimaryColor(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPaymentType = value!;
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.monetization_on, color: primaryColor),
                                const SizedBox(width: 8),
                                const Text(
                                  'Datos de Pago',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            // Solo mostrar el campo de monto
                            TextFormField(
                              controller: _amountController,
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
                              validator: _validateAmount,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.notifications, color: primaryColor),
                                const SizedBox(width: 8),
                                const Text(
                                  'Notificación',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            // Selector de tipo de notificación
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Método de notificación',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedNotificationType,
                              items: _notificationMethods.entries.map((entry) {
                                return DropdownMenuItem(
                                  value: entry.key,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getNotificationIcon(entry.key),
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(entry.value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedNotificationType = newValue!;
                                  // Limpiar el campo cuando se cambia el tipo
                                  _recipientController.clear();
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Campo para el destinatario de la notificación
                            TextFormField(
                              controller: _recipientController,
                              decoration: InputDecoration(
                                labelText: 'Destinatario',
                                hintText: _getRecipientHintText(),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor, width: 2),
                                ),
                                prefixIcon: Icon(
                                  _getNotificationIcon(_selectedNotificationType),
                                  color: primaryColor,
                                ),
                              ),
                              keyboardType: _selectedNotificationType == 'email' 
                                  ? TextInputType.emailAddress 
                                  : _selectedNotificationType == 'sms' || _selectedNotificationType == 'ws'
                                      ? TextInputType.phone 
                                      : TextInputType.text,
                              validator: _validateRecipient,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Procesar Pago con ${factory.getMethodName()}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
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
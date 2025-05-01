import 'dart:convert';
import 'package:front_pago/models/payment_request.dart';
import 'package:front_pago/models/payment_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:front_pago/factories/debit_card_theme_factory.dart';
import 'package:front_pago/factories/paypal_card_theme_factory.dart';

import '../factories/credit_card_theme_factory.dart';
import '../factories/interfaces_abstractas/payment_theme_factory.dart';

class PaymentProvider extends ChangeNotifier {
  final String apiUrl = 'http://localhost:8080/api/payments/process';
  
  String _selectedPaymentType = 'CREDIT_CARD';
  String _selectedNotificationType = 'email';
  bool _isLoading = false;
  
  // Getters
  String get selectedPaymentType => _selectedPaymentType;
  String get selectedNotificationType => _selectedNotificationType;
  bool get isLoading => _isLoading;
  
  // Mapa de fábricas para los métodos de pago
  final Map<String, PaymentThemeFactory> factories = {
    'CREDIT_CARD': CreditCardThemeFactory(),
    'DEBIT_CARD': DebitCardThemeFactory(),
    'PAYPAL': PayPalThemeFactory(),
  };
  
  // Mapa de métodos de notificación
  final Map<String, String> notificationMethods = {
    'email': 'Correo Electrónico',
    'sms': 'Mensaje SMS',
    'ws': 'Whatsapp',
  };
  
  // Cambiar método de pago
  void setPaymentType(String type) {
    _selectedPaymentType = type;
    notifyListeners();
  }
  
  // Cambiar método de notificación
  void setNotificationType(String type) {
    _selectedNotificationType = type;
    notifyListeners();
  }
  
  // Procesar el pago
  Future<PaymentResponse?> processPayment(PaymentRequest request) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        body: jsonEncode(request.toJson()),
      );
      
      _isLoading = false;
      notifyListeners();
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return PaymentResponse.fromJson(responseData);
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Obtener el color primario actual
  Color get currentPrimaryColor => 
    factories[_selectedPaymentType]?.getPrimaryColor() ?? Colors.blue;
  
  // Obtener el nombre del método de pago actual
  String get currentPaymentMethodName => 
    factories[_selectedPaymentType]?.getMethodName() ?? 'Tarjeta de Crédito';
  
  // Obtener el ícono para el tipo de notificación
  IconData getNotificationIcon(String type) {
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
  
  // Obtener el nombre amigable del tipo de notificación
  String getNotificationName(String type) {
    return notificationMethods[type] ?? 'Desconocido';
  }
  
  // Texto de ayuda para el formato del destinatario
  String getRecipientHintText() {
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
}
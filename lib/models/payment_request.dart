import 'package:front_pago/models/notification_request.dart';

class PaymentRequest {
  final String paymentType;
  final double amount;
  final String notificationType;
  final String notificationRecipient;
  
  // Nuevos campos opcionales que pueden ser útiles para la integración
  final String? subject;
  final String? message;
  final NotificationRequest? notificationDetails;

  PaymentRequest({
    required this.paymentType,
    required this.amount,
    required this.notificationType,
    required this.notificationRecipient,
    this.subject,
    this.message,
    this.notificationDetails,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'paymentType': paymentType,
      'amount': amount,
      'notificationType': notificationType,
      'notificationRecipient': notificationRecipient,
    };

    // Añadir campos opcionales si están presentes
    if (subject != null) data['subject'] = subject;
    if (message != null) data['message'] = message;
    
    // Añadir detalles de notificación completos si están disponibles
    if (notificationDetails != null) {
      data['notificationDetails'] = notificationDetails!.toJson();
    }

    return data;
  }
}
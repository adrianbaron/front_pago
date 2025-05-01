class PaymentResponse {
  final double originalAmount;
  final double finalAmount;
  final bool notificationSent;
  final String? notificationMessage;
  final String? transactionId;
  
  PaymentResponse({
    required this.originalAmount,
    required this.finalAmount,
    required this.notificationSent,
    this.notificationMessage,
    this.transactionId,
  });
  
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      originalAmount: json['originalAmount'].toDouble(),
      finalAmount: json['finalAmount'].toDouble(),
      notificationSent: json['notificationSent'] ?? false,
      notificationMessage: json['notificationMessage'],
      transactionId: json['transactionId'],
    );
  }
  
  // Calcular la comisión
  double get commission => finalAmount - originalAmount;
  
  // Datos para el reporte
  Map<String, dynamic> toReportData(String paymentType, String notificationType, String recipient) {
    return {
      'transactionId': transactionId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'paymentType': paymentType,
      'originalAmount': originalAmount,
      'finalAmount': finalAmount,
      'paymentDate': DateTime.now().toIso8601String(),
      'status': 'Completado',
      'notificationType': notificationType,
      'notificationRecipient': recipient,
    };
  }
}
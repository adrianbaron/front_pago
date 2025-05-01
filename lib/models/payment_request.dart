class PaymentRequest {
  final String paymentType;
  final double amount;
  final String notificationType;
  final String notificationRecipient;
  
  PaymentRequest({
    required this.paymentType,
    required this.amount,
    required this.notificationType,
    required this.notificationRecipient,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'paymentType': paymentType,
      'amount': amount,
      'notificationType': notificationType,
      'notificationRecipient': notificationRecipient,
    };
  }
}
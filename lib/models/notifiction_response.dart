// lib/models/notification_response.dart
class NotificationResponse {
  final bool success;
  final String type;
  final String recipient;
  final String message;

  NotificationResponse({
    required this.success,
    required this.type,
    required this.recipient,
    required this.message,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      type: json['type'] ?? '',
      recipient: json['recipient'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
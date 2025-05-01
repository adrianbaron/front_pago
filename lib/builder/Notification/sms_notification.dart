import 'package:front_pago/builder/Notification/notification_base.dart';

class SMSNotification implements Notification {
  final String phoneNumber;
  final String message;
  final String? senderId;
  final bool? deliveryReportRequired;
  final DateTime? scheduleTime;

  SMSNotification({
    required this.phoneNumber,
    required this.message,
    this.senderId,
    this.deliveryReportRequired,
    this.scheduleTime,
  });

  @override
  String get type => 'sms';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'phoneNumber': phoneNumber,
      'message': message,
      if (senderId != null) 'senderId': senderId,
      if (deliveryReportRequired != null) 'deliveryReportRequired': deliveryReportRequired,
      if (scheduleTime != null) 'scheduleTime': scheduleTime?.toIso8601String(),
    };
  }
}
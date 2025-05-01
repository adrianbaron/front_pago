import 'package:front_pago/builder/Notification/notification_base.dart';

class EmailNotification implements Notification {
  final String to;
  final String subject;
  final String body;
  final List<String>? cc;
  final List<String>? bcc;
  final List<String>? attachments;
  final String? priority;

  EmailNotification({
    required this.to,
    required this.subject,
    required this.body,
    this.cc,
    this.bcc,
    this.attachments,
    this.priority,
  });

  @override
  String get type => 'email';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'to': to,
      'subject': subject,
      'body': body,
      if (cc != null) 'cc': cc,
      if (bcc != null) 'bcc': bcc,
      if (attachments != null) 'attachments': attachments,
      if (priority != null) 'priority': priority,
    };
  }
}
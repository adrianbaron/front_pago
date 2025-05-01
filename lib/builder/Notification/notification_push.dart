// Notificación Push
import 'package:front_pago/builder/Notification/notification_base.dart';

class PushNotification implements Notification {
  final String deviceToken;
  final String title;
  final String message;
  final String? imageUrl;
  final String? clickAction;
  final String? priority;

  PushNotification({
    required this.deviceToken,
    required this.title,
    required this.message,
    this.imageUrl,
    this.clickAction,
    this.priority,
  });

  @override
  String get type => 'push';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'deviceToken': deviceToken,
      'title': title,
      'message': message,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (clickAction != null) 'clickAction': clickAction,
      if (priority != null) 'priority': priority,
    };
  }
}
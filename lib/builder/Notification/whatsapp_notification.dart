import 'package:front_pago/builder/Notification/notification_base.dart';

class WhatsAppNotification implements Notification {
  final String phoneNumber;
  final String message;
  final String? mediaUrl;
  final String? caption;
  final List<String>? interactiveButtons;
  final String? language;

  WhatsAppNotification({
    required this.phoneNumber,
    required this.message,
    this.mediaUrl,
    this.caption,
    this.interactiveButtons,
    this.language,
  });

  @override
  String get type => 'whatsapp';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'phoneNumber': phoneNumber,
      'message': message,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      if (caption != null) 'caption': caption,
      if (interactiveButtons != null) 'interactiveButtons': interactiveButtons,
      if (language != null) 'language': language,
    };
  }
}

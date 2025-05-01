// lib/models/notification_request.dart
class NotificationRequest {
  final String type;
  final String recipient;
  final String subject;
  final String message;
  
  // Campos específicos para Email
  final List<String>? cc;
  final List<String>? bcc;
  final List<String>? attachments;
  final String? emailPriority;
  
  // Campos específicos para SMS
  final String? senderId;
  final bool? deliveryReportRequired;
  final String? scheduleTime;
  
  // Campos específicos para Push
  final String? imageUrl;
  final String? clickAction;
  final String? pushPriority;
  
  // Campos específicos para WhatsApp
  final String? mediaUrl;
  final String? caption;
  final List<String>? interactiveButtons;
  final String? language;

  NotificationRequest({
    required this.type,
    required this.recipient,
    required this.subject,
    required this.message,
    
    // Email
    this.cc,
    this.bcc,
    this.attachments,
    this.emailPriority,
    
    // SMS
    this.senderId,
    this.deliveryReportRequired,
    this.scheduleTime,
    
    // Push
    this.imageUrl,
    this.clickAction,
    this.pushPriority,
    
    // WhatsApp
    this.mediaUrl,
    this.caption,
    this.interactiveButtons,
    this.language,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'recipient': recipient,
      'subject': subject,
      'message': message,
    };
    
    // Agregar campos específicos según el tipo de notificación
    switch (type.toLowerCase()) {
      case 'email':
        if (cc != null) data['cc'] = cc;
        if (bcc != null) data['bcc'] = bcc;
        if (attachments != null) data['attachments'] = attachments;
        if (emailPriority != null) data['emailPriority'] = emailPriority;
        break;
        
      case 'sms':
        if (senderId != null) data['senderId'] = senderId;
        if (deliveryReportRequired != null) data['deliveryReportRequired'] = deliveryReportRequired;
        if (scheduleTime != null) data['scheduleTime'] = scheduleTime;
        break;
        
      case 'push':
        if (imageUrl != null) data['imageUrl'] = imageUrl;
        if (clickAction != null) data['clickAction'] = clickAction;
        if (pushPriority != null) data['pushPriority'] = pushPriority;
        break;
        
      case 'ws':
        if (mediaUrl != null) data['mediaUrl'] = mediaUrl;
        if (caption != null) data['caption'] = caption;
        if (interactiveButtons != null) data['interactiveButtons'] = interactiveButtons;
        if (language != null) data['language'] = language;
        break;
    }
    
    return data;
  }
}
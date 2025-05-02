import 'package:flutter/material.dart';
import 'package:front_pago/models/notification_request.dart';
import 'package:front_pago/provider/payment_provider.dart';
import 'package:front_pago/utils/validators.dart';
import 'package:front_pago/widgets/common/custom_card.dart';
import 'package:front_pago/widgets/common/section_header.dart';
import 'package:provider/provider.dart';

class NotificationSelector extends StatefulWidget {
  final TextEditingController recipientController;
  final Function(NotificationRequest) onNotificationDataReady;
  
  const NotificationSelector({
    Key? key,
    required this.recipientController,
    required this.onNotificationDataReady,
  }) : super(key: key);

  @override
  State<NotificationSelector> createState() => _NotificationSelectorState();
}

class _NotificationSelectorState extends State<NotificationSelector> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  
  // Controladores específicos para email
  final TextEditingController _ccController = TextEditingController();
  final TextEditingController _bccController = TextEditingController();
  final TextEditingController _attachmentsController = TextEditingController();
  String? _emailPriority;
  
  // Controladores específicos para SMS
  final TextEditingController _senderIdController = TextEditingController();
  bool _deliveryReportRequired = false;
  DateTime? _scheduleTime;
  
  // Controladores específicos para Push
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _clickActionController = TextEditingController();
  String? _pushPriority;
  
  // Controladores específicos para WhatsApp
  final TextEditingController _mediaUrlController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _interactiveButtonsController = TextEditingController();
  String? _language;
  
  @override
  void dispose() {
    _messageController.dispose();
    _subjectController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _attachmentsController.dispose();
    _senderIdController.dispose();
    _imageUrlController.dispose();
    _clickActionController.dispose();
    _mediaUrlController.dispose();
    _captionController.dispose();
    _interactiveButtonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final primaryColor = paymentProvider.currentPrimaryColor;
    
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.notifications,
            title: 'Notificación',
            color: primaryColor,
          ),
          const Divider(height: 24),
          // Selector de tipo de notificación
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Método de notificación',
              border: OutlineInputBorder(),
            ),
            value: paymentProvider.selectedNotificationType,
            items: paymentProvider.notificationMethods.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Row(
                  children: [
                    Icon(
                      paymentProvider.getNotificationIcon(entry.key),
                      size: 20,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(entry.value),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                paymentProvider.setNotificationType(newValue);
                // Limpiar el campo cuando se cambia el tipo
                widget.recipientController.clear();
                // Actualizar los datos de notificación
                _updateNotificationData();
              }
            },
          ),
          const SizedBox(height: 16),
          // Campo para el destinatario de la notificación
          TextFormField(
            controller: widget.recipientController,
            decoration: InputDecoration(
              labelText: 'Destinatario',
              hintText: paymentProvider.getRecipientHintText(),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              prefixIcon: Icon(
                paymentProvider.getNotificationIcon(paymentProvider.selectedNotificationType),
                color: primaryColor,
              ),
            ),
            keyboardType: paymentProvider.selectedNotificationType == 'email' 
                ? TextInputType.emailAddress 
                : TextInputType.phone,
            validator: (value) => Validators.validateRecipient(
              value, 
              paymentProvider.selectedNotificationType
            ),
            onChanged: (_) => _updateNotificationData(),
          ),
          const SizedBox(height: 16),
          // Campo para el asunto (común pero principalmente para email)
          TextFormField(
            controller: _subjectController,
            decoration: InputDecoration(
              labelText: 'Asunto',
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              prefixIcon: Icon(Icons.subject, color: primaryColor),
            ),
            validator: (value) => value == null || value.isEmpty ? 'El asunto es requerido' : null,
            onChanged: (_) => _updateNotificationData(),
          ),
          const SizedBox(height: 16),
          // Campo para el mensaje (común para todos los tipos)
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: 'Mensaje',
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              prefixIcon: Icon(Icons.message, color: primaryColor),
            ),
            maxLines: 3,
            validator: (value) => value == null || value.isEmpty ? 'El mensaje es requerido' : null,
            onChanged: (_) => _updateNotificationData(),
          ),
          
          // Campos específicos según el tipo de notificación
          if (paymentProvider.selectedNotificationType == 'email')
            _buildEmailFields(primaryColor),
          if (paymentProvider.selectedNotificationType == 'sms')
            _buildSmsFields(primaryColor),
          if (paymentProvider.selectedNotificationType == 'push')
            _buildPushFields(primaryColor),
          if (paymentProvider.selectedNotificationType == 'ws')
            _buildWhatsappFields(primaryColor),
        ],
      ),
    );
  }

  Widget _buildEmailFields(Color primaryColor) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _ccController,
          decoration: InputDecoration(
            labelText: 'CC (separados por coma)',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.people, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bccController,
          decoration: InputDecoration(
            labelText: 'BCC (separados por coma)',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.people_outline, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _attachmentsController,
          decoration: InputDecoration(
            labelText: 'Adjuntos (URLs separadas por coma)',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.attach_file, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Prioridad',
            border: OutlineInputBorder(),
          ),
          value: _emailPriority ?? 'normal',
          items: ['alta', 'normal', 'baja'].map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Text(priority.toUpperCase()),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _emailPriority = newValue;
                _updateNotificationData();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildSmsFields(Color primaryColor) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _senderIdController,
          decoration: InputDecoration(
            labelText: 'ID del Remitente',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.person, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Requerir informe de entrega'),
          value: _deliveryReportRequired,
          activeColor: primaryColor,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            if (value != null) {
              setState(() {
                _deliveryReportRequired = value;
                _updateNotificationData();
              });
            }
          },
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.schedule, color: primaryColor),
          title: Text(_scheduleTime == null 
              ? 'Programar envío' 
              : 'Programado para: ${_formatDateTime(_scheduleTime!)}'),
          onTap: () async {
            final dateTime = await _selectDateTime(context);
            if (dateTime != null) {
              setState(() {
                _scheduleTime = dateTime;
                _updateNotificationData();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildPushFields(Color primaryColor) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _imageUrlController,
          decoration: InputDecoration(
            labelText: 'URL de la imagen',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.image, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _clickActionController,
          decoration: InputDecoration(
            labelText: 'Acción al hacer clic',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.touch_app, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Prioridad de la notificación',
            border: OutlineInputBorder(),
          ),
          value: _pushPriority ?? 'normal',
          items: ['alta', 'normal', 'baja'].map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Text(priority.toUpperCase()),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _pushPriority = newValue;
                _updateNotificationData();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildWhatsappFields(Color primaryColor) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _mediaUrlController,
          decoration: InputDecoration(
            labelText: 'URL del archivo multimedia',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.attachment, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _captionController,
          decoration: InputDecoration(
            labelText: 'Subtítulo para el archivo multimedia',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.closed_caption, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _interactiveButtonsController,
          decoration: InputDecoration(
            labelText: 'Botones interactivos (separados por coma)',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.smart_button, color: primaryColor),
          ),
          onChanged: (_) => _updateNotificationData(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: TextEditingController(text: _language ?? 'es'),
          decoration: InputDecoration(
            labelText: 'Código de idioma (ej: es, en, pt)',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.language, color: primaryColor),
          ),
          onChanged: (value) {
            setState(() {
              _language = value;
              _updateNotificationData();
            });
          },
        ),
      ],
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date == null) return null;
    
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (time == null) return null;
    
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
  
  // Método para generar la solicitud de notificación
  NotificationRequest _createNotificationRequest() {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final type = paymentProvider.selectedNotificationType;
    
    switch (type) {
      case 'email':
        return NotificationRequest(
          type: type,
          recipient: widget.recipientController.text,
          subject: _subjectController.text,
          message: _messageController.text,
          cc: _ccController.text.isNotEmpty 
            ? _ccController.text.split(',').map((e) => e.trim()).toList() 
            : null,
          bcc: _bccController.text.isNotEmpty 
            ? _bccController.text.split(',').map((e) => e.trim()).toList() 
            : null,
          attachments: _attachmentsController.text.isNotEmpty 
            ? _attachmentsController.text.split(',').map((e) => e.trim()).toList() 
            : null,
          emailPriority: _emailPriority,
        );
        
      case 'sms':
        return NotificationRequest(
          type: type,
          recipient: widget.recipientController.text,
          subject: _subjectController.text,
          message: _messageController.text,
          senderId: _senderIdController.text.isNotEmpty ? _senderIdController.text : null,
          deliveryReportRequired: _deliveryReportRequired,
          scheduleTime: _scheduleTime?.toIso8601String(),
        );
        
      case 'push':
        return NotificationRequest(
          type: type,
          recipient: widget.recipientController.text,
          subject: _subjectController.text,
          message: _messageController.text,
          imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
          clickAction: _clickActionController.text.isNotEmpty ? _clickActionController.text : null,
          pushPriority: _pushPriority,
        );
        
      case 'ws':
        return NotificationRequest(
          type: type,
          recipient: widget.recipientController.text,
          subject: _subjectController.text,
          message: _messageController.text,
          mediaUrl: _mediaUrlController.text.isNotEmpty ? _mediaUrlController.text : null,
          caption: _captionController.text.isNotEmpty ? _captionController.text : null,
          interactiveButtons: _interactiveButtonsController.text.isNotEmpty 
            ? _interactiveButtonsController.text.split(',').map((e) => e.trim()).toList() 
            : null,
          language: _language,
        );
        
      default:
        return NotificationRequest(
          type: type,
          recipient: widget.recipientController.text,
          subject: _subjectController.text,
          message: _messageController.text,
        );
    }
  }
  
  // Método para actualizar los datos de notificación
  void _updateNotificationData() {
    // Verificar que los campos obligatorios estén llenos antes de llamar al callback
    if (widget.recipientController.text.isNotEmpty && 
        _subjectController.text.isNotEmpty && 
        _messageController.text.isNotEmpty) {
      final request = _createNotificationRequest();
      widget.onNotificationDataReady(request);
    }
  }
}
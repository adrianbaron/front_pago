import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:front_pago/builder/payment/payment_report_config.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PaymentReportGenerator {
  final PaymentReportConfig config;
  final Map<String, dynamic> paymentData;

  PaymentReportGenerator({
    required this.config,
    required this.paymentData,
  });

  Future<Uint8List> generatePdfReport() async {
    final pdf = pw.Document();
    
    // Cargar imagen para logo si está configurado
    pw.MemoryImage? logoImage;
    if (config.includeLogo) {
      try {
        final logoBytes = await _loadLogoBytes();
        if (logoBytes != null) {
          logoImage = pw.MemoryImage(logoBytes);
        }
      } catch (e) {
        print('Error al cargar el logo: $e');
      }
    }

    // Definir colores según el tema
    final PdfColor primaryColor = config.theme == ReportTheme.LIGHT 
        ? PdfColors.blue700 
        : PdfColors.lightBlue;
    final PdfColor textColor = config.theme == ReportTheme.LIGHT 
        ? PdfColors.black 
        : PdfColors.white;
    final PdfColor backgroundColor = config.theme == ReportTheme.LIGHT 
        ? PdfColors.white 
        : PdfColors.blueGrey800;
    
    // Definir el tamaño de página según el formato
    final pageFormat = config.format == ReportFormat.A4 
        ? PdfPageFormat.a4 
        : PdfPageFormat.letter;

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Container(
            color: backgroundColor,
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Encabezado
                pw.Container(
                  padding: const pw.EdgeInsets.only(bottom: 20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            config.title,
                            style: pw.TextStyle(
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          if (config.includeTimestamp)
                            pw.Text(
                              'Fecha: ${_formatDateTime(DateTime.now())}',
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      if (logoImage != null)
                        pw.Image(
                          logoImage,
                          height: 60,
                        ),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 20),
                
                // Detalles del pago
                if (config.includePaymentDetails) ...[
                  _buildSectionTitle('Detalles del Pago', primaryColor, textColor),
                  pw.SizedBox(height: 10),
                  _buildPaymentDetailsSection(primaryColor, textColor),
                  pw.SizedBox(height: 20),
                ],
                
                // Información del usuario
                if (config.includeUserInfo && paymentData.containsKey('userInfo')) ...[
                  _buildSectionTitle('Información del Cliente', primaryColor, textColor),
                  pw.SizedBox(height: 10),
                  _buildUserInfoSection(primaryColor, textColor),
                  pw.SizedBox(height: 20),
                ],
                
                // Resumen del pago
                _buildSectionTitle('Resumen', primaryColor, textColor),
                pw.SizedBox(height: 10),
                _buildSummarySection(primaryColor, textColor),
                
                // Espaciador que empuja el pie de página hacia abajo
                pw.Spacer(),
                
                // Pie de página
                pw.Container(
                  padding: const pw.EdgeInsets.only(top: 20),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(
                        color: primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        config.footerMessage,
                        style: pw.TextStyle(
                          color: textColor,
                          fontSize: 12,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'ID de transacción: ${paymentData['transactionId'] ?? 'N/A'}',
                        style: pw.TextStyle(
                          color: textColor.complementary,
                          fontSize: 10,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildSectionTitle(String title, PdfColor primaryColor, PdfColor textColor) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: primaryColor,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildPaymentDetailsSection(PdfColor primaryColor, PdfColor textColor) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: primaryColor.complementary),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          _buildDetailRow('Tipo de Pago', paymentData['paymentType'] ?? 'N/A', textColor),
          _buildDetailRow('Monto', '\$${paymentData['finalAmount']?.toStringAsFixed(2) ?? '0.00'}', textColor),
          _buildDetailRow('Comisión', '\$${_calculateCommission().toStringAsFixed(2)}', textColor),
          _buildDetailRow('Fecha', _formatDateTime(DateTime.parse(paymentData['paymentDate'] ?? DateTime.now().toIso8601String())), textColor),
          _buildDetailRow('Estado', paymentData['status'] ?? 'Completado', textColor),
        ],
      ),
    );
  }

  pw.Widget _buildUserInfoSection(PdfColor primaryColor, PdfColor textColor) {
    final userInfo = paymentData['userInfo'] as Map<String, dynamic>? ?? {};
    
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: primaryColor.complementary),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          _buildDetailRow('Nombre', userInfo['name'] ?? 'N/A', textColor),
          _buildDetailRow('Email', userInfo['email'] ?? 'N/A', textColor),
          if (userInfo.containsKey('phone'))
            _buildDetailRow('Teléfono', userInfo['phone'] ?? 'N/A', textColor),
          if (userInfo.containsKey('address'))
            _buildDetailRow('Dirección', userInfo['address'] ?? 'N/A', textColor),
        ],
      ),
    );
  }

  pw.Widget _buildSummarySection(PdfColor primaryColor, PdfColor textColor) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: primaryColor.complementary,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          _buildDetailRow('Método de Pago', _getPaymentMethodName(), textColor),
          _buildDetailRow('Monto Original', '\$${paymentData['originalAmount']?.toStringAsFixed(2) ?? '0.00'}', textColor),
          _buildDetailRow('Monto Final', '\$${paymentData['finalAmount']?.toStringAsFixed(2) ?? '0.00'}', textColor, bold: true),
          if (paymentData.containsKey('notificationType'))
            _buildDetailRow('Notificación Enviada a', 
              '${paymentData['notificationRecipient'] ?? 'N/A'} (${_getNotificationTypeName()})', 
              textColor),
        ],
      ),
    );
  }

  pw.Widget _buildDetailRow(String label, String value, PdfColor textColor, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: bold ? pw.FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName() {
    switch (paymentData['paymentType']) {
      case 'CREDIT_CARD':
        return 'Tarjeta de Crédito';
      case 'DEBIT_CARD':
        return 'Tarjeta de Débito';
      case 'PAYPAL':
        return 'PayPal';
      default:
        return paymentData['paymentType'] ?? 'Desconocido';
    }
  }

  String _getNotificationTypeName() {
    switch (paymentData['notificationType']) {
      case 'email':
        return 'Correo Electrónico';
      case 'sms':
        return 'Mensaje SMS';
      case 'ws':
        return 'WhatsApp';
      default:
        return paymentData['notificationType'] ?? 'Desconocido';
    }
  }

  double _calculateCommission() {
    final originalAmount = paymentData['originalAmount'] as double? ?? 0.0;
    final finalAmount = paymentData['finalAmount'] as double? ?? 0.0;
    return finalAmount - originalAmount;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Esta función simula la carga de un logo de ejemplo
  Future<Uint8List?> _loadLogoBytes() async {
  try {
    final ByteData bytes = await rootBundle.load('assets/LOGO.PNG');
    return bytes.buffer.asUint8List();
  } catch (e) {
    print('Error cargando el logo: $e');
    return null;
  }
}
}


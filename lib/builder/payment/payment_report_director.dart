import 'package:flutter/material.dart';
import 'package:front_pago/builder/payment/payment_report_builder.dart';
import 'package:front_pago/builder/payment/payment_report_config.dart';
import 'package:front_pago/builder/payment/payment_report_generator.dart';
import 'package:printing/printing.dart';

class PaymentReportDirector {
  // Método para crear un reporte estándar básico
  static PaymentReportConfig createStandardReport() {
    return PaymentReportBuilder()
        .withLogo(true)
        .withTitle("Comprobante de Pago")
        .withPaymentDetails(true)
        .withUserInfo(true)
        .withTheme(ReportTheme.LIGHT)
        .withTimestamp(true)
        .withFooterMessage("Gracias por su pago")
        .withFormat(ReportFormat.A4)
        .build();
  }
  
  // Método para crear un reporte resumido
  static PaymentReportConfig createSummaryReport() {
    return PaymentReportBuilder()
        .withLogo(true)
        .withTitle("Resumen de Pago")
        .withPaymentDetails(false)
        .withUserInfo(false)
        .withTheme(ReportTheme.LIGHT)
        .withTimestamp(true)
        .withFooterMessage("Comprobante simplificado")
        .withFormat(ReportFormat.A4)
        .build();
  }
  
  // Método para crear un reporte detallado con tema oscuro
  static PaymentReportConfig createDetailedDarkReport() {
    return PaymentReportBuilder()
        .withLogo(true)
        .withTitle("Detalle Completo de Transacción")
        .withPaymentDetails(true)
        .withUserInfo(true)
        .withTheme(ReportTheme.DARK)
        .withTimestamp(true)
        .withFooterMessage("Documento oficial de pago")
        .withFormat(ReportFormat.LETTER)
        .build();
  }
}

// Ejemplo de uso en payment_screen.dart
Future<void> generateAndShowReport(Map<String, dynamic> paymentData, BuildContext context) async {
  // Crear configuración de reporte
  final reportConfig = PaymentReportBuilder()
      .withLogo(true)
      .withTitle("Comprobante de Pago")
      .withPaymentDetails(true)
      .withUserInfo(true)
      .withTheme(ReportTheme.LIGHT)
      .withTimestamp(true)
      .withFooterMessage("Gracias por su pagoooo")
      .withFormat(ReportFormat.A4)
      .build();
  
  // O usar configuraciones predefinidas
  // final reportConfig = PaymentReportDirector.createStandardReport();
  
  // Generar PDF
  final generator = PaymentReportGenerator(
    config: reportConfig,
    paymentData: paymentData,
  );
  
  final pdfBytes = await generator.generatePdfReport();
  
  // Mostrar PDF o compartirlo
  await Printing.sharePdf(
    bytes: pdfBytes, 
    filename: 'comprobante_pago_${DateTime.now().millisecondsSinceEpoch}.pdf'
  );
}

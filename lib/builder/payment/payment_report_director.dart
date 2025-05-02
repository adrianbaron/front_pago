// payment_report_director.dart
import 'package:front_pago/builder/payment/payment_report_config.dart';

class PaymentReportDirector {
  // Prototipos de reportes comunes
  static final PaymentReportConfig _standardPrototype = PaymentReportConfig(
    includeLogo: true,
    title: "Comprobante de Pago",
    includePaymentDetails: true,
    includeUserInfo: true,
    theme: ReportTheme.LIGHT,
    includeTimestamp: true,
    footerMessage: "Gracias por su pago",
    format: ReportFormat.A4,
  );

  static final PaymentReportConfig _summaryPrototype = PaymentReportConfig(
    includeLogo: true,
    title: "Resumen de Pago",
    includePaymentDetails: false,
    includeUserInfo: false,
    theme: ReportTheme.LIGHT,
    includeTimestamp: true,
    footerMessage: "Comprobante simplificado",
    format: ReportFormat.A4,
  );

  static final PaymentReportConfig _detailedDarkPrototype = PaymentReportConfig(
    includeLogo: true,
    title: "Detalle Completo de Transacción",
    includePaymentDetails: true,
    includeUserInfo: true,
    theme: ReportTheme.DARK,
    includeTimestamp: true,
    footerMessage: "Documento oficial de pago",
    format: ReportFormat.LETTER,
  );

  // Método para obtener un reporte estándar (usando clone)
  static PaymentReportConfig createStandardReport() {
    return _standardPrototype.clone();
  }
  
  // Método para obtener un reporte resumido (usando clone)
  static PaymentReportConfig createSummaryReport() {
    return _summaryPrototype.clone();
  }
  
  // Método para obtener un reporte detallado oscuro (usando clone)
  static PaymentReportConfig createDetailedDarkReport() {
    return _detailedDarkPrototype.clone();
  }
  
  // Método para crear un reporte estándar con modificaciones
  static PaymentReportConfig createCustomStandardReport({
    String? title,
    String? footerMessage,
    ReportTheme? theme,
  }) {
    return _standardPrototype.toBuilder()
      .withTitle(title ?? _standardPrototype.title)
      .withFooterMessage(footerMessage ?? _standardPrototype.footerMessage)
      .withTheme(theme ?? _standardPrototype.theme)
      .build();
  }
  
  // Método para crear un reporte resumido con modificaciones
  static PaymentReportConfig createCustomSummaryReport({
    String? title,
    String? footerMessage,
    bool? includeUserInfo,
  }) {
    return _summaryPrototype.toBuilder()
      .withTitle(title ?? _summaryPrototype.title)
      .withFooterMessage(footerMessage ?? _summaryPrototype.footerMessage)
      .withUserInfo(includeUserInfo ?? _summaryPrototype.includeUserInfo)
      .build();
  }
}

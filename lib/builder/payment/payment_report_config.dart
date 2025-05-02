// payment_report_config.dart
import 'package:front_pago/builder/payment/payment_report_builder.dart';

enum ReportTheme {
  LIGHT,
  DARK
}

enum ReportFormat {
  A4,
  LETTER
}

class PaymentReportConfig {
  bool includeLogo;
  String title;
  bool includePaymentDetails;
  bool includeUserInfo;
  ReportTheme theme;
  bool includeTimestamp;
  String footerMessage;
  ReportFormat format;

  PaymentReportConfig({
    required this.includeLogo,
    required this.title,
    required this.includePaymentDetails,
    required this.includeUserInfo,
    required this.theme,
    required this.includeTimestamp,
    required this.footerMessage,
    required this.format,
  });

  // Método clone para el patrón Prototype
  PaymentReportConfig clone() {
    return PaymentReportConfig(
      includeLogo: this.includeLogo,
      title: this.title,
      includePaymentDetails: this.includePaymentDetails,
      includeUserInfo: this.includeUserInfo,
      theme: this.theme,
      includeTimestamp: this.includeTimestamp,
      footerMessage: this.footerMessage,
      format: this.format,
    );
  }

  // Método toBuilder para convertir la configuración en un builder
  // Esto facilita modificar una configuración existente
  PaymentReportBuilder toBuilder() {
    return PaymentReportBuilder()
      ..withLogo(this.includeLogo)
      ..withTitle(this.title)
      ..withPaymentDetails(this.includePaymentDetails)
      ..withUserInfo(this.includeUserInfo)
      ..withTheme(this.theme)
      ..withTimestamp(this.includeTimestamp)
      ..withFooterMessage(this.footerMessage)
      ..withFormat(this.format);
  }
}
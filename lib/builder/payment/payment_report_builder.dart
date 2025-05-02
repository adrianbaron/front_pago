// payment_report_builder.dart
import 'package:front_pago/builder/payment/payment_report_config.dart';

class PaymentReportBuilder {
  bool _includeLogo = true;
  String _title = "Reporte de Pago";
  bool _includePaymentDetails = true;
  bool _includeUserInfo = true;
  ReportTheme _theme = ReportTheme.LIGHT;
  bool _includeTimestamp = true;
  String _footerMessage = "Gracias por su pago";
  ReportFormat _format = ReportFormat.A4;

  // Constructor por defecto vacío
  PaymentReportBuilder();

  // Constructor que acepta un prototipo
  PaymentReportBuilder.fromPrototype(PaymentReportConfig prototype) {
    _includeLogo = prototype.includeLogo;
    _title = prototype.title;
    _includePaymentDetails = prototype.includePaymentDetails;
    _includeUserInfo = prototype.includeUserInfo;
    _theme = prototype.theme;
    _includeTimestamp = prototype.includeTimestamp;
    _footerMessage = prototype.footerMessage;
    _format = prototype.format;
  }

  PaymentReportBuilder withLogo(bool include) {
    _includeLogo = include;
    return this;
  }

  PaymentReportBuilder withTitle(String title) {
    _title = title;
    return this;
  }

  PaymentReportBuilder withPaymentDetails(bool include) {
    _includePaymentDetails = include;
    return this;
  }

  PaymentReportBuilder withUserInfo(bool include) {
    _includeUserInfo = include;
    return this;
  }

  PaymentReportBuilder withTheme(ReportTheme theme) {
    _theme = theme;
    return this;
  }

  PaymentReportBuilder withTimestamp(bool include) {
    _includeTimestamp = include;
    return this;
  }

  PaymentReportBuilder withFooterMessage(String message) {
    _footerMessage = message;
    return this;
  }

  PaymentReportBuilder withFormat(ReportFormat format) {
    _format = format;
    return this;
  }

  PaymentReportConfig build() {
    return PaymentReportConfig(
      includeLogo: _includeLogo,
      title: _title,
      includePaymentDetails: _includePaymentDetails,
      includeUserInfo: _includeUserInfo,
      theme: _theme,
      includeTimestamp: _includeTimestamp,
      footerMessage: _footerMessage,
      format: _format,
    );
  }
}
class PaymentReportConfig {
  final bool includeLogo;
  final String title;
  final bool includePaymentDetails;
  final bool includeUserInfo;
  final ReportTheme theme;
  final bool includeTimestamp;
  final String footerMessage;
  final ReportFormat format;

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
}

enum ReportTheme { LIGHT, DARK }
enum ReportFormat { A4, LETTER }
import 'package:flutter/material.dart';
import 'package:front_pago/builder/payment/payment_report_builder.dart';
import 'package:front_pago/builder/payment/payment_report_config.dart';
import 'package:front_pago/builder/payment/payment_report_director.dart';
import 'package:front_pago/builder/payment/payment_report_generator.dart';
import 'package:front_pago/provider/payment_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';


class ReportConfigurationScreen extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  
  const ReportConfigurationScreen({
    Key? key, 
    required this.paymentData,
  }) : super(key: key);

  @override
  State<ReportConfigurationScreen> createState() => _ReportConfigurationScreenState();
 
}

class _ReportConfigurationScreenState extends State<ReportConfigurationScreen> {
  // Estado para las opciones de configuración
  bool includeLogo = true;
  String title = "Comprobante de Pago";
  bool includePaymentDetails = true;
  bool includeUserInfo = true;
  ReportTheme theme = ReportTheme.LIGHT;
  bool includeTimestamp = true;
  String footerMessage = "Gracias por su pago";
  ReportFormat format = ReportFormat.A4;
  
  // Lista de plantillas predefinidas
  final List<String> templates = [
    "Personalizado",
    "Estándar",
    "Resumido",
    "Detallado Oscuro"
  ];
  
  String selectedTemplate = "Personalizado";
  
  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final primaryColor = paymentProvider.currentPrimaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Reporte'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selector de plantilla predefinida
            Card(
              color: primaryColor,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecciona una plantilla',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedTemplate,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      items: templates.map((String template) {
                        return DropdownMenuItem<String>(
                          value: template,
                          child: Text(template),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedTemplate = newValue;
                            _applyTemplate(newValue);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Opciones de Configuración
            if (selectedTemplate == "Personalizado") ...[
              _buildConfigSection(
                title: 'Opciones Básicas',
                children: [
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text('Incluir Logo'),
                    value: includeLogo,
                    onChanged: (bool value) {
                      setState(() {
                        includeLogo = value;
                      });
                    },
                  ),
                  const Divider(),
                  TextFormField(
                    cursorColor: primaryColor,
                    initialValue: title,
                    decoration: const InputDecoration(
                      labelText: 'Título del Reporte',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        title = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    cursorColor: primaryColor,
                    initialValue: footerMessage,
                    decoration: const InputDecoration(
                      labelText: 'Mensaje de Pie de Página',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        footerMessage = value;
                      });
                    },
                  ),
                ],
              ),
              
              _buildConfigSection(
                title: 'Contenido',
                children: [
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text('Incluir Detalles del Pago'),
                    value: includePaymentDetails,
                    onChanged: (bool value) {
                      setState(() {
                        includePaymentDetails = value;
                      });
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text('Incluir Información del Usuario'),
                    value: includeUserInfo,
                    onChanged: (bool value) {
                      setState(() {
                        includeUserInfo = value;
                      });
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeColor: primaryColor,
                    title: const Text('Incluir Fecha y Hora'),
                    value: includeTimestamp,
                    onChanged: (bool value) {
                      setState(() {
                        includeTimestamp = value;
                      });
                    },
                  ),
                ],
              ),
              
              _buildConfigSection(
                title: 'Aspecto',
                children: [
                  ListTile(
                    iconColor: primaryColor,
                    title: const Text('Tema'),
                    trailing: SegmentedButton<ReportTheme>(
                      segments: const [
                        ButtonSegment<ReportTheme>(
                          value: ReportTheme.LIGHT,
                          label: Text('Claro'),
                          icon: Icon(Icons.light_mode),
                        ),
                        ButtonSegment<ReportTheme>(
                          value: ReportTheme.DARK,
                          label: Text('Oscuro'),
                          icon: Icon(Icons.dark_mode),
                        ),
                      ],
                      selected: {theme},
                      onSelectionChanged: (Set<ReportTheme> newSelection) {
                        setState(() {
                          theme = newSelection.first;
                        });
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    iconColor: primaryColor,
                    title: const Text('Formato de Página'),
                    trailing: SegmentedButton<ReportFormat>(
                      segments: const [
                        ButtonSegment<ReportFormat>(
                          value: ReportFormat.A4,
                          label: Text('A4'),
                        ),
                        ButtonSegment<ReportFormat>(
                          value: ReportFormat.LETTER,
                          label: Text('Carta'),
                        ),
                      ],
                      selected: {format},
                      onSelectionChanged: (Set<ReportFormat> newSelection) {
                        setState(() {
                          format = newSelection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Botón para generar el reporte
            ElevatedButton.icon(
              
              onPressed: () => _generateReport(context),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generar Reporte'),
              style: ElevatedButton.styleFrom(
                iconColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ), 
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConfigSection({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
  
  void _applyTemplate(String template) {
    PaymentReportConfig config;
    
    switch (template) {
      case "Estándar":
        config = PaymentReportDirector.createStandardReport();
        break;
      case "Resumido":
        config = PaymentReportDirector.createSummaryReport();
        break;
      case "Detallado Oscuro":
        config = PaymentReportDirector.createDetailedDarkReport();
        break;
      default:
        return; // Mantener la configuración personalizada actual
    }
    
    // Actualizar el estado con la configuración de la plantilla
    setState(() {
      includeLogo = config.includeLogo;
      title = config.title;
      includePaymentDetails = config.includePaymentDetails;
      includeUserInfo = config.includeUserInfo;
      theme = config.theme;
      includeTimestamp = config.includeTimestamp;
      footerMessage = config.footerMessage;
      format = config.format;
    });
  }
  
  Future<void> _generateReport(BuildContext context) async {
    try {
      // Crear configuración personalizada usando el builder
      final reportConfig = PaymentReportBuilder()
          .withLogo(includeLogo)
          .withTitle(title)
          .withPaymentDetails(includePaymentDetails)
          .withUserInfo(includeUserInfo)
          .withTheme(theme)
          .withTimestamp(includeTimestamp)
          .withFooterMessage(footerMessage)
          .withFormat(format)
          .build();
      
      // Generar el PDF
      final generator = PaymentReportGenerator(
        config: reportConfig,
        paymentData: widget.paymentData,
      );
      
      final pdfBytes = await generator.generatePdfReport();
      
      // Compartir el PDF
      if (context.mounted) {
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: 'comprobante_pago_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
        Navigator.pop(context); // Opcional: cerrar la pantalla de configuración
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar el reporte: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
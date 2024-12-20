import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/excel_service.dart';
import '../widgets/daily_trend_chart.dart';
import '../widgets/line_trend_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExcelService _excelService = ExcelService();
  List<Map<String, dynamic>> _data = [];

  /// Cargar un archivo Excel/CSV
  void _loadFile() async {
    final file = await _excelService.pickFile();
    if (file != null) {
      List<Map<String, dynamic>> data = [];
      if (file.path.endsWith('.xlsx')) {
        data = _excelService.readExcel(file);
      } else if (file.path.endsWith('.csv')) {
        data = _excelService.readCsv(file);
      }

      if (_excelService.isValidData(data)) {
        setState(() {
          _data = data; // Actualiza los datos cargados
        });
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("El archivo cargado no es válido o tiene un formato incorrecto."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Filtrar datos por rango de fechas
  void _filterByDateRange(DateTimeRange? range) {
    if (range != null) {
      setState(() {
        _data = _data.where((row) {
          final date = DateTime.parse(row['Fecha']);
          return date.isAfter(range.start) && date.isBefore(range.end);
        }).toList();
      });
    }
  }

  /// Exportar los datos a un archivo PDF
  void _exportToPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Text("Dashboard Report", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                data: [
                  ["Fecha", "Objetivo", "Entregado", "Aprovechamiento"],
                  ..._data.map((row) => [
                        row['Fecha'],
                        row['Objetivo'],
                        row['Entregado'],
                        row['Aprovechamiento'],
                      ])
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Interactivo")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _loadFile,
                  child: const Text("Cargar Archivo"),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5),
                ElevatedButton(
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    _filterByDateRange(range);
                  },
                  child: const Text("Filtrar por Fecha"),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5),
                ElevatedButton(
                  onPressed: _exportToPdf,
                  child: const Text("Exportar a PDF"),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5),
              ],
            ),
            const SizedBox(height: 20),
            if (_data.isNotEmpty) ...[
              DailyTrendChart(data: _data)
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideX(begin: -0.5), // Gráfico de barras con animación
              const SizedBox(height: 20),
              LineTrendChart(data: _data)
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideX(begin: 0.5), // Gráfico de líneas con animación
            ] else ...[
              const Text("No hay datos cargados.")
                  .animate()
                  .fadeIn(duration: 700.ms),
            ],
          ],
        ),
      ),
    );
  }
}

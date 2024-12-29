import 'package:flutter/material.dart';
import '../services/excel_service.dart';
import '../widgets/daily_trend_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExcelService _excelService = ExcelService();
  List<Map<String, dynamic>> _data = [];
  Map<String, double> _aggregatedData = {};
  String _statusMessage = "Cargue un archivo para comenzar.";

  /// Cargar archivo y validar datos
  void _loadFile() async {
    final file = await _excelService.pickFile();
    if (file != null) {
      setState(() {
        _statusMessage = "Procesando archivo...";
        _data = [];
        _aggregatedData = {};
      });

      print("Archivo seleccionado: ${file.path}"); // Verificar ruta del archivo

      await for (final chunk in _excelService.readExcelInChunks(file)) {
        setState(() {
          _data.addAll(chunk);
        });
        print("Chunk procesado: ${chunk.length} filas añadidas."); // Confirmar datos procesados
      }

      print("Total de datos procesados: ${_data.length} filas."); // Validar total de datos

      setState(() {
        _aggregatedData = _aggregateData(_data);
        _statusMessage = "Archivo procesado. ${_aggregatedData.length} días validados.";
      });

      print("Datos agregados para el gráfico: $_aggregatedData"); // Verificar datos agrupados
    } else {
      setState(() {
        _statusMessage = "No se seleccionó ningún archivo.";
      });
    }
  }

  /// Agrupar datos por fecha y sumar cantidades
  Map<String, double> _aggregateData(List<Map<String, dynamic>> data) {
    Map<String, double> aggregated = {};

    for (var row in data) {
      final date = row["Fecha Entrega"];
      final quantity = row["Cantidad entrega"];
      if (date != null && quantity != null && quantity is num) {
        aggregated[date] = (aggregated[date] ?? 0.0) + quantity.toDouble();
      }
    }

    return aggregated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Interactivo"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _loadFile,
              child: const Text("Cargar Archivo"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _statusMessage,
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          ),
          if (_aggregatedData.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: _aggregatedData.entries.map((entry) {
                    return ListTile(
                      title: Text("Fecha: ${entry.key}"),
                      subtitle: Text("Cantidad: ${entry.value}"),
                    );
                  }).toList(),
                ),
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  "No hay datos válidos para mostrar.",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

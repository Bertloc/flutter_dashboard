import 'package:flutter/material.dart';
import '../services/excel_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ExcelService _excelService = ExcelService();
  List<Map<String, dynamic>> _data = [];
  String _statusMessage = "Cargue un archivo para comenzar la validación.";

  /// Cargar y validar datos
  void _loadAndValidateFile() async {
    final file = await _excelService.pickFile();
    if (file != null) {
      setState(() {
        _statusMessage = "Procesando archivo...";
      });

      await for (final chunk in _excelService.readExcelInChunks(file)) {
        setState(() {
          _data.addAll(chunk);
        });
      }

      setState(() {
        _statusMessage = "Archivo procesado correctamente. ${_data.length} filas validadas.";
      });
    } else {
      setState(() {
        _statusMessage = "No se seleccionó ningún archivo.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Validación de Datos"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _loadAndValidateFile,
              child: const Text("Cargar y Validar Archivo"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _statusMessage,
              style: const TextStyle(color: Colors.blueAccent, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final row = _data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text("Fila ${index + 1}"),
                    subtitle: Text(row.entries
                        .map((e) => "${e.key}: ${e.value}")
                        .join(", ")),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

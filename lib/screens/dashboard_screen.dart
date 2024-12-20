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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Interactivo")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loadFile,
              child: const Text("Cargar Archivo"),
            ),
            if (_data.isNotEmpty)
              DailyTrendChart(data: _data), // Gráfico conectado a datos dinámicos
          ],
        ),
      ),
    );
  }
}


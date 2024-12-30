import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/excel_service.dart';
import '../widgets/pie_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  File? selectedFile;
  List<Map<String, dynamic>>? responseData;
  bool isLoading = false; // Indicador de carga

  final ExcelService excelService = ExcelService();

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selecciona un archivo primero.")));
      return;
    }

    setState(() {
      isLoading = true; // Activa el indicador de carga
    });

    try {
      final data = await excelService.uploadFile(selectedFile!);
      setState(() {
        responseData = data;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Archivo procesado con éxito.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        isLoading = false; // Desactiva el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text("Seleccionar Archivo"),
            ),
            SizedBox(height: 16),
            if (selectedFile != null) Text("Archivo seleccionado: ${selectedFile!.path}"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : uploadFile, // Deshabilita el botón si está cargando
              child: Text("Subir y Procesar"),
            ),
            SizedBox(height: 16),
            if (isLoading)
              Center(child: CircularProgressIndicator()), // Indicador de carga
            if (responseData != null && !isLoading)
              Expanded(
                child: Column(
                  children: [
                    PieChartWidget(data: responseData!), // Gráfico de pastel
                    Expanded(
                      child: ListView(
                        children: responseData!.map((item) {
                          return ListTile(
                            title: Text(item['Estatus Pedido']),
                            subtitle: Text("Cantida Pedido: ${item['Cantida Pedido']}"),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

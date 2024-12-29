import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../services/excel_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key); // Asegúrate de agregar este constructor.

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  File? selectedFile;
  List<Map<String, dynamic>>? responseData;

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

    try {
      final data = await excelService.uploadFile(selectedFile!);
      setState(() {
        responseData = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al subir el archivo: $e")));
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
              onPressed: uploadFile,
              child: Text("Subir y Procesar"),
            ),
            SizedBox(height: 16),
            if (responseData != null)
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
    );
  }
}

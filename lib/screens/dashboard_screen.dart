import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/compliance_pie_chart.dart';
import '../widgets/DailyTrendLineChart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  File? selectedFile;
  List<Map<String, dynamic>> clients = [];
  String? selectedClientId;
  List<Map<String, dynamic>> complianceData = [];
  List<Map<String, dynamic>> dailyTrendData = [];
  bool isLoading = false;
  String? errorMessage;

  final Dio dio = Dio();
  final String baseUrl = "https://backend-processing.onrender.com/api";

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      setState(() => errorMessage = "Error al seleccionar archivo: $e");
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) {
      setState(() => errorMessage = "Por favor, selecciona un archivo.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final formData = FormData.fromMap({"file": await MultipartFile.fromFile(selectedFile!.path)});
      final response = await dio.post("$baseUrl/upload", data: formData);
      final List<dynamic> responseClients = response.data["clientes"];

      if (responseClients.isEmpty) {
        setState(() => errorMessage = "No se encontraron clientes en el archivo.");
        return;
      }

      clients = List<Map<String, dynamic>>.from(responseClients);
      clients.sort((a, b) => a["Nombre Solicitante"].toString().compareTo(b["Nombre Solicitante"].toString()));
      errorMessage = null;
    } catch (e) {
      setState(() => errorMessage = "Error al cargar el archivo.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleClientSelect(String? clientId) async {
    if (clientId == null || selectedFile == null) return;

    setState(() {
      selectedClientId = clientId;
      isLoading = true;
      errorMessage = null;
    });

    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(selectedFile!.path),
        "client_id": clientId,
      });

      final responses = await Future.wait([
        dio.post("$baseUrl/compliance-summary", data: formData),
        dio.post("$baseUrl/api/daily-trend", data: formData),
      ]);

      complianceData = (responses[0].data as Map<String, dynamic>).entries
          .map((entry) => {"label": entry.key, "value": entry.value})
          .toList();

      dailyTrendData = (responses[1].data as List<dynamic>)
          .map((entry) => {"x": entry["Fecha Entrega"], "y": entry["Cantidad entrega"]})
          .toList();

    } catch (e) {
      setState(() => errorMessage = "Error al obtener los datos del cliente.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard - Selección de Cliente")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Seleccionar Archivo"),
            ),
            const SizedBox(height: 16),
            if (selectedFile != null)
              ElevatedButton(
                onPressed: uploadFile,
                child: const Text("Subir Archivo"),
              ),
            if (isLoading) const CircularProgressIndicator(),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (clients.isNotEmpty)
              DropdownButton<String>(
                value: selectedClientId,
                hint: const Text("Selecciona un cliente"),
                items: clients
                    .map((client) => DropdownMenuItem(
                          value: client["Solicitante"].toString(),
                          child: Text(client["Nombre Solicitante"]),
                        ))
                    .toList(),
                onChanged: (value) => handleClientSelect(value!),
              ),
            if (selectedClientId != null) ...[
              const SizedBox(height: 16),
              CompliancePieChart(data: complianceData),
              DailyTrendLineChart(data: dailyTrendData),
            ],
          ],
        ),
      ),
    );
  }
}

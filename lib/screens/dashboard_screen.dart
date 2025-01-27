import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/compliance_pie_chart.dart';
import '../widgets/DailyTrendLineChart.dart';
import '../widgets/MonthlyProductAllocationBarChart.dart';
import '../widgets/DistributionByCenterPieChart.dart';
import '../widgets/DailySummaryLineChart.dart';
import '../widgets/PendingOrdersBarChart.dart';
import '../widgets/ProductCategorySummaryPieChart.dart';

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
  List<Map<String, dynamic>> monthlyProductData = [];
  List<Map<String, dynamic>> distributionByCenterData = [];
  List<Map<String, dynamic>> dailySummaryData = [];
  List<Map<String, dynamic>> pendingOrdersData = [];
  List<Map<String, dynamic>> productCategoryData = [];
  List<Map<String, dynamic>> dailyDeliveryData = [];
  List<Map<String, dynamic>> reportDeliveryTrendsData = [];
  List<Map<String, dynamic>> deliveryReportData = [];
  bool isLoading = false;
  String? errorMessage;

  final Dio dio = Dio(); // Cliente HTTP
  final String baseUrl =
      "https://backend-processing.onrender.com/api"; // URL del backend en producción

  // Selección de archivo
  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      setState(() => errorMessage = "Error al seleccionar archivo: $e");
    }
  }

  // Subida del archivo y obtención de clientes
  Future<void> uploadFile() async {
    if (selectedFile == null || selectedFile!.path.isEmpty) {
      setState(() => errorMessage = "Por favor, selecciona un archivo válido.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(selectedFile!.path),
      });

      final response = await dio.post("$baseUrl/upload", data: formData);

      // Verifica que la respuesta tenga datos
      if (response.data == null || response.data["clientes"] == null) {
        setState(() {
          errorMessage = "No se encontraron clientes en el archivo.";
        });
        return;
      }

      final List<dynamic> responseClients = response.data["clientes"];
      clients = List<Map<String, dynamic>>.from(responseClients);

      // Ordenar clientes por nombre alfabéticamente
      clients.sort((a, b) => a["Nombre Solicitante"]
          .toString()
          .compareTo(b["Nombre Solicitante"].toString()));

      errorMessage = null;
    } on DioError catch (e) {
      setState(() {
        errorMessage =
            e.response?.data["error"] ?? "Error al procesar el archivo.";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error inesperado: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Manejar selección de cliente y obtener datos de gráficos
  // Manejar selección de cliente y obtener datos de gráficos
  Future<void> handleClientSelect(String? clientId) async {
    if (clientId == null || selectedFile == null) return;

    setState(() {
      selectedClientId = clientId;
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Enviar todas las solicitudes concurrentemente, creando un FormData único para cada una
      final responses = await Future.wait([
        dio.post(
          "$baseUrl/compliance-summary",
          data: FormData.fromMap({
            "file": await MultipartFile.fromFile(selectedFile!.path),
            "client_id": clientId,
          }),
        ),
        dio.post(
          "$baseUrl/api/daily-trend",
          data: FormData.fromMap({
            "file": await MultipartFile.fromFile(selectedFile!.path),
            "client_id": clientId,
          }),
        ),
        dio.post(
          "$baseUrl/api/monthly-product-allocation",
          data: FormData.fromMap({
            "file": await MultipartFile.fromFile(selectedFile!.path),
            "client_id": clientId,
          }),
        ),
        dio.post(
          "$baseUrl/api/distribution-by-center",
          data: FormData.fromMap({
            "file": await MultipartFile.fromFile(selectedFile!.path),
            "client_id": clientId,
          }),
        ),
        dio.post(
          "$baseUrl/api/daily-summary",
          data: FormData.fromMap({
            "file": await MultipartFile.fromFile(selectedFile!.path),
            "client_id": clientId,
          }),
        ),
        dio.post(
          "$baseUrl/api/pending-orders",
          data: FormData.fromMap({
            "file": await MultipartFile.fromFile(selectedFile!.path),
            "client_id": clientId,
          }),
        ),
        dio.post(
          "$baseUrl/api/product-category-summary",
          data: FormData.fromMap({
            "file": await MultipartFile.fromFile(selectedFile!.path),
            "client_id": clientId,
          }),
        ),
      ]);

      // Procesar las respuestas
      complianceData = (responses[0].data as Map<String, dynamic>)
          .entries
          .map((entry) => {"label": entry.key, "value": entry.value})
          .toList();

      dailyTrendData = (responses[1].data as List<dynamic>)
          .map((entry) =>
              {"x": entry["Fecha Entrega"], "y": entry["Cantidad entrega"]})
          .toList();

      monthlyProductData = (responses[2].data as List<dynamic>)
          .map((entry) =>
              {"Mes": entry["Mes"], "Cantidad": entry["Cantida Pedido"]})
          .toList();

      distributionByCenterData = (responses[3].data as List<dynamic>)
          .map((entry) =>
              {"label": entry["Centro"], "value": entry["Cantidad entrega"]})
          .toList();

      dailySummaryData = (responses[4].data as List<dynamic>)
          .map((entry) =>
              {"x": entry["Fecha Entrega"], "y": entry["% Aprovechamiento"]})
          .toList();

      pendingOrdersData = (responses[5].data as List<dynamic>)
          .map((entry) => {
                "label": entry["Material"],
                "value": entry["Cantidad confirmada"]
              })
          .toList();

      productCategoryData = (responses[6].data as List<dynamic>)
          .map((entry) => {
                "label": entry["Texto breve de material"],
                "value": entry["Cantida Pedido"]
              })
          .toList();

      dailyDeliveryData = (responses[7].data as List<dynamic>)
          .map((entry) => {"x": entry["Fecha"], "y": entry["Total Entregado"]})
          .toList();

      reportDeliveryTrendsData = (responses[8].data as List<dynamic>)
          .map((entry) =>
              {"x": entry["Fecha Entrega"], "y": entry["Cantidad entrega"]})
          .toList();

      deliveryReportData = (responses[9].data as List<dynamic>)
          .map((entry) =>
              {"label": entry["Material"], "value": entry["Cantidad entrega"]})
          .toList();
    } on DioError catch (e) {
      print("Error al obtener datos del cliente: $e");
      setState(() {
        errorMessage = e.response?.data["error"] ?? "Error desconocido.";
      });
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: 16),
              if (isLoading) const Center(child: CircularProgressIndicator()),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
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
                const SizedBox(height: 16),
                DailyTrendLineChart(data: dailyTrendData),
                const SizedBox(height: 16),
                MonthlyProductAllocationBarChart(data: monthlyProductData),
                const SizedBox(height: 16),
                DistributionByCenterPieChart(data: distributionByCenterData),
                const SizedBox(height: 16),
                DailySummaryLineChart(data: dailySummaryData),
                const SizedBox(height: 16),
                PendingOrdersBarChart(data: pendingOrdersData),
                const SizedBox(height: 16),
                ProductCategorySummaryPieChart(data: productCategoryData),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

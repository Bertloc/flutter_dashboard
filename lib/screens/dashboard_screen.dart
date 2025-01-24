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
import '../widgets/DailyDeliveryReportLineChart.dart';
import '../widgets/ReportDeliveryTrendsLineChart.dart';
import '../widgets/DeliveryReportBarChart.dart';

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
    if (selectedFile == null) {
      setState(() => errorMessage = "Por favor, selecciona un archivo.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final formData = FormData.fromMap(
          {"file": await MultipartFile.fromFile(selectedFile!.path)});
      final response = await dio.post("$baseUrl/upload", data: formData);
      final List<dynamic> responseClients = response.data["clientes"];
      if (responseClients.isEmpty) {
        setState(
            () => errorMessage = "No se encontraron clientes en el archivo.");
        return;
      }
      clients = List<Map<String, dynamic>>.from(responseClients);

      // Ordenar clientes por nombre alfabéticamente
      clients.sort((a, b) => a["Nombre Solicitante"]
          .toString()
          .compareTo(b["Nombre Solicitante"].toString()));

      errorMessage = null;
    } on DioError catch (e) {
      if (e.response != null && e.response!.data["error"] != null) {
        setState(() => errorMessage = e.response!.data["error"]);
      } else {
        setState(() => errorMessage = "Error al procesar el archivo.");
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Manejar selección de cliente y obtener datos de gráficos
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

      // Solicitud 1: Compliance Summary
      final complianceResponse =
          await dio.post("$baseUrl/compliance-summary", data: formData);
      complianceData = (complianceResponse.data as Map<String, dynamic>)
          .entries
          .map((entry) => {"label": entry.key, "value": entry.value})
          .toList();

      // Solicitud 2: Daily Trend
      final dailyTrendResponse =
          await dio.post("$baseUrl/api/daily-trend", data: formData);
      dailyTrendData = (dailyTrendResponse.data as List<dynamic>)
          .map((entry) =>
              {"x": entry["Fecha Entrega"], "y": entry["Cantidad entrega"]})
          .toList();

      // Solicitud 3: Monthly Product Allocation
      final monthlyProductResponse = await dio
          .post("$baseUrl/api/monthly-product-allocation", data: formData);
      monthlyProductData = (monthlyProductResponse.data as List<dynamic>)
          .map((entry) =>
              {"Mes": entry["Mes"], "Cantidad": entry["Cantida Pedido"]})
          .toList();

      // Solicitud 4: Distribution by Center
      final distributionResponse =
          await dio.post("$baseUrl/api/distribution-by-center", data: formData);
      distributionByCenterData = (distributionResponse.data as List<dynamic>)
          .map((entry) =>
              {"label": entry["Centro"], "value": entry["Cantidad entrega"]})
          .toList();

      // Solicitud 5: Daily Summary
      final dailySummaryResponse =
          await dio.post("$baseUrl/api/daily-summary", data: formData);
      dailySummaryData = (dailySummaryResponse.data as List<dynamic>)
          .map((entry) =>
              {"x": entry["Fecha Entrega"], "y": entry["% Aprovechamiento"]})
          .toList();

      // Solicitud 6: Pending Orders
      final pendingOrdersResponse =
          await dio.post("$baseUrl/api/pending-orders", data: formData);
      pendingOrdersData = (pendingOrdersResponse.data as List<dynamic>)
          .map((entry) => {
                "label": entry["Material"],
                "value": entry["Cantidad confirmada"]
              })
          .toList();

      // Solicitud 7: Product Category Summary
      final productCategoryResponse = await dio
          .post("$baseUrl/api/product-category-summary", data: formData);
      productCategoryData = (productCategoryResponse.data as List<dynamic>)
          .map((entry) => {
                "label": entry["Texto breve de material"],
                "value": entry["Cantida Pedido"]
              })
          .toList();

      // Solicitud 8: Daily Delivery Report
      final dailyDeliveryResponse =
          await dio.post("$baseUrl/api/daily-delivery-report", data: formData);
      dailyDeliveryData = (dailyDeliveryResponse.data as List<dynamic>)
          .map((entry) => {"x": entry["Fecha"], "y": entry["Total Entregado"]})
          .toList();

      // Solicitud 9: Report Delivery Trends
      final reportTrendsResponse =
          await dio.post("$baseUrl/api/report-delivery-trends", data: formData);
      reportDeliveryTrendsData = (reportTrendsResponse.data as List<dynamic>)
          .map((entry) =>
              {"x": entry["Fecha Entrega"], "y": entry["Cantidad entrega"]})
          .toList();

      // Solicitud 10: Delivery Report
      final deliveryReportResponse =
          await dio.post("$baseUrl/api/delivery-report", data: formData);
      deliveryReportData = (deliveryReportResponse.data as List<dynamic>)
          .map((entry) =>
              {"label": entry["Material"], "value": entry["Cantidad entrega"]})
          .toList();
    } on DioError catch (e) {
      if (e.response != null && e.response!.data["error"] != null) {
        setState(() => errorMessage = e.response!.data["error"]);
      } else {
        setState(() => errorMessage = "Error al obtener datos del cliente.");
      }
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
                const SizedBox(height: 16),
                DailyDeliveryReportLineChart(data: dailyDeliveryData),
                const SizedBox(height: 16),
                ReportDeliveryTrendsLineChart(data: reportDeliveryTrendsData),
                const SizedBox(height: 16),
                DeliveryReportBarChart(data: deliveryReportData),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

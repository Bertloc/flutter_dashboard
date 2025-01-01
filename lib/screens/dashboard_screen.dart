import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/delivery_trends_chart_widget.dart';
import '../widgets/daily_delivery_report_widget.dart';
import '../widgets/distribution_by_center_widget.dart';
import '../widgets/summary_table_widget.dart';
import '../widgets/pending_orders_widget.dart';
import '../widgets/product_category_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  File? selectedFile;
  List<Map<String, dynamic>>? pieChartData;
  List<Map<String, dynamic>>? lineChartData;
  List<Map<String, dynamic>>? barChartData;
  List<Map<String, dynamic>>? deliveryTrendsData;
  List<Map<String, dynamic>>? dailyDeliveryData;
  List<Map<String, dynamic>>? distributionData;
  List<Map<String, dynamic>>? summaryTableData;
  List<Map<String, dynamic>>? pendingOrdersData;
  List<Map<String, dynamic>>? productCategoryData;
  final ApiService apiService = ApiService();
  bool isLoading = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> generateAllCharts() async {
    if (selectedFile == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      pieChartData = await apiService.uploadFile(selectedFile!);
      lineChartData = await apiService.fetchDailyTrend(selectedFile!);
      barChartData = await apiService.fetchMonthlyProductAllocation(selectedFile!);
      deliveryTrendsData = await apiService.fetchDeliveryTrends(selectedFile!);
      dailyDeliveryData = await apiService.fetchDailyDeliveryReport(selectedFile!);
      distributionData = await apiService.fetchDistributionByCenter(selectedFile!);
      summaryTableData = await apiService.fetchDailySummary(selectedFile!);
      pendingOrdersData = await apiService.fetchPendingOrders(selectedFile!);
      productCategoryData = await apiService.fetchProductCategorySummary(selectedFile!);
    } catch (e) {
      showError(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Seleccionar Archivo"),
            ),
            const SizedBox(height: 16),
            if (selectedFile != null) Text("Archivo seleccionado: ${selectedFile!.path}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedFile == null || isLoading ? null : generateAllCharts,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Generar Todas las Gráficas"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        if (pieChartData != null) PieChartWidget(data: pieChartData!),
                        if (lineChartData != null) LineChartWidget(data: lineChartData!),
                        if (barChartData != null) BarChartWidget(data: barChartData!),
                        if (deliveryTrendsData != null)
                          DeliveryTrendsChartWidget(data: deliveryTrendsData!),
                        if (dailyDeliveryData != null)
                          DailyDeliveryReportWidget(data: dailyDeliveryData!),
                        if (distributionData != null)
                          DistributionByCenterWidget(data: distributionData!),
                        if (summaryTableData != null) SummaryTableWidget(data: summaryTableData!),
                        if (pendingOrdersData != null) PendingOrdersWidget(data: pendingOrdersData!),
                        if (productCategoryData != null)
                          ProductCategoryWidget(data: productCategoryData!),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {
  final String baseUrl = "http://192.168.1.170:5000/api";

  // Método existente: Procesar archivo y obtener resumen por estatus
  Future<List<Map<String, dynamic>>> uploadFile(File file) async {
    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload"));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al procesar el archivo");
    }
  }

  // Método: Obtener datos de la Tendencia Diaria
  Future<List<Map<String, dynamic>>> fetchDailyTrend(File file) async {
    final request =
        http.MultipartRequest("POST", Uri.parse("$baseUrl/api/daily-trend")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener datos de la tendencia diaria");
    }
  }

  // Método: Obtener datos de asignación mensual por producto
  Future<List<Map<String, dynamic>>> fetchMonthlyProductAllocation(File file) async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("$baseUrl/api/monthly-product-allocation")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener datos de asignación mensual");
    }
  }

  // Método: Obtener datos de tendencias de entrega
  Future<List<Map<String, dynamic>>> fetchDeliveryTrends(File file) async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("$baseUrl/api/report-delivery-trends")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener datos de tendencias de entrega");
    }
  }

  // Método: Obtener datos del reporte de entrega diaria
  Future<List<Map<String, dynamic>>> fetchDailyDeliveryReport(File file) async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("$baseUrl/api/delivery-report")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener datos del reporte de entrega diaria");
    }
  }

  // Método: Obtener datos de distribución por centro
  Future<List<Map<String, dynamic>>> fetchDistributionByCenter(File file) async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("$baseUrl/api/distribution-by-center")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener datos de distribución por centro");
    }
  }

  // Método: Obtener resumen diario
  Future<List<Map<String, dynamic>>> fetchDailySummary(File file) async {
    final request =
        http.MultipartRequest("POST", Uri.parse("$baseUrl/api/daily-summary")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener el resumen diario");
    }
  }

  // Método: Obtener pedidos pendientes
  Future<List<Map<String, dynamic>>> fetchPendingOrders(File file) async {
    final request =
        http.MultipartRequest("POST", Uri.parse("$baseUrl/api/pending-orders")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener los pedidos pendientes");
    }
  }

  // Método: Obtener resumen por categoría de producto
  Future<List<Map<String, dynamic>>> fetchProductCategorySummary(File file) async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("$baseUrl/api/product-category-summary")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener el resumen por categoría de producto");
    }
  }

  // Método: Obtener reporte de entrega diaria
  Future<List<Map<String, dynamic>>> fetchDailyDelivery(File file) async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("$baseUrl/api/daily-delivery-report")); // Corrigiendo endpoint
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al obtener el reporte diario de entrega");
    }
  }
}

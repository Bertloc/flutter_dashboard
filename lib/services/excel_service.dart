import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ExcelService {
  final String baseUrl = "http://192.168.1.170:5000/api"; // Actualiza con la IP correcta si usas red local.

  Future<List<Map<String, dynamic>>> uploadFile(File file) async {
    final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload"));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseData));
    } else {
      throw Exception("Error al procesar el archivo: ${response.statusCode}");
    }
  }
}

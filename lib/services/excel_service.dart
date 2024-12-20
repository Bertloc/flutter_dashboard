import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';

class ExcelService {
  /// Método para seleccionar un archivo Excel o CSV
  Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'], // Extensiones permitidas
    );
    if (result != null) {
      return File(result.files.single.path!); // Retorna el archivo seleccionado
    }
    return null; // Si no se seleccionó un archivo
  }

  /// Método para leer datos desde un archivo Excel
 List<Map<String, dynamic>> readExcel(File file) {
  final bytes = file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);

  List<Map<String, dynamic>> data = [];
  final sheet = excel.sheets[excel.sheets.keys.first]; // Usa la primera hoja
  if (sheet != null) {
    for (var i = 1; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      data.add({
        "Fecha": row[0]?.value.toString() ?? "", // Convertir a String
        "Objetivo": _parseDouble(row[1]?.value), // Convertir a Double
        "Entregado": _parseDouble(row[2]?.value),
        "Aprovechamiento": _parseDouble(row[3]?.value),
      });
    }
  }
  return data; // Retorna los datos procesados
}

/// Método auxiliar para convertir valores a Double
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return 0.0; // Valor por defecto si no se puede convertir
}

  /// Método para leer datos desde un archivo CSV
  List<Map<String, dynamic>> readCsv(File file) {
    final input = file.openRead();
    final fields = input.transform(utf8.decoder).transform(CsvToListConverter());

    List<Map<String, dynamic>> data = [];
    int rowIndex = 0;
    List<dynamic> headers = [];
    fields.listen((row) {
      if (rowIndex == 0) {
        headers = row; // Usa la primera fila como encabezados
      } else {
        Map<String, dynamic> rowData = {};
        for (int i = 0; i < headers.length; i++) {
          rowData[headers[i].toString()] = row[i];
        }
        data.add(rowData);
      }
      rowIndex++;
    });
    return data; // Retorna los datos procesados
  }

  /// Validar si los datos cargados son válidos
  bool isValidData(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return false;
    // Verifica que todas las claves principales existan en el primer mapa
    return data.first.containsKey('Fecha') &&
           data.first.containsKey('Objetivo') &&
           data.first.containsKey('Entregado') &&
           data.first.containsKey('Aprovechamiento');
  }
}

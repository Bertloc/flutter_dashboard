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
  Stream<List<Map<String, dynamic>>> readExcelInChunks(File file, {int chunkSize = 100}) async* {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.sheets[excel.sheets.keys.first];

    if (sheet != null && sheet.rows.isNotEmpty) {
      final headers = sheet.rows[0].map((cell) => cell?.value?.toString().trim() ?? "").toList();

      for (int start = 1; start < sheet.rows.length; start += chunkSize) {
        List<Map<String, dynamic>> chunk = [];

        for (int i = start; i < start + chunkSize && i < sheet.rows.length; i++) {
          final row = sheet.rows[i];
          final rowData = <String, dynamic>{};

          for (var j = 0; j < headers.length; j++) {
            final header = headers[j];
            final cellValue = row[j]?.value;

            rowData[header] = cellValue ?? "N/A"; // Manejo de valores nulos
          }
          chunk.add(rowData);
        }

        yield _validateChunk(chunk); // Validación y limpieza
      }
    }
  }

  /// Método para leer datos desde un archivo CSV
  Stream<List<Map<String, dynamic>>> readCsvInChunks(File file, {int chunkSize = 100}) async* {
    final input = file.openRead();
    final fields = input.transform(utf8.decoder).transform(CsvToListConverter()).asBroadcastStream();
    final headers = await fields.first;

    List<List<dynamic>> rows = [];
    await for (var row in fields.skip(1)) {
      rows.add(row);
      if (rows.length == chunkSize) {
        yield _mapRowsToData(rows, headers);
        rows.clear();
      }
    }
    if (rows.isNotEmpty) {
      yield _mapRowsToData(rows, headers);
    }
  }

  /// Validar y limpiar datos por chunks
  List<Map<String, dynamic>> _validateChunk(List<Map<String, dynamic>> chunk) {
    return chunk.map((row) {
      row.forEach((key, value) {
        if (value == null || value.toString().trim().isEmpty) {
          row[key] = key.contains("Cantidad") || key.contains("Volumen") ? 0.0 : "N/A";
        }
      });
      return row;
    }).toList();
  }

  /// Mapear filas y encabezados
  List<Map<String, dynamic>> _mapRowsToData(List<List<dynamic>> rows, List<dynamic> headers) {
    return rows.map((row) {
      final rowData = <String, dynamic>{};
      for (int i = 0; i < headers.length; i++) {
        rowData[headers[i].toString()] = row.length > i ? row[i] ?? "N/A" : "N/A";
      }
      return rowData;
    }).toList();
  }

  /// Obtener datos únicos por columna
  List<String> getUniqueValues(String columnName, List<Map<String, dynamic>> data) {
    return data.map((row) => row[columnName]?.toString() ?? "N/A").toSet().toList();
  }

  /// Validar si los datos cargados son válidos
  bool isValidData(List<Map<String, dynamic>> data) {
    return data.isNotEmpty && data.first.keys.isNotEmpty;
  }
}

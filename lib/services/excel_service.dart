import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';

class ExcelService {
  /// Permite al usuario seleccionar un archivo .xlsx
  Future<File?> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path;
        if (path != null) {
          return File(path);
        } else {
          throw Exception("No se pudo obtener la ruta del archivo.");
        }
      }
      return null; // Si no se selecciona un archivo
    } catch (e) {
      debugPrint("Error al seleccionar archivo: $e");
      return null;
    }
  }

  /// Lee un archivo Excel en chunks para manejar archivos grandes
  Stream<List<Map<String, dynamic>>> readExcelInChunks(File file, {int chunkSize = 100}) async* {
    try {
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        final rows = excel.tables[table]?.rows ?? [];
        if (rows.isEmpty) {
          continue;
        }

        final headers = rows.first.map((header) => header?.value?.toString() ?? "").toList();

        List<Map<String, dynamic>> chunk = [];
        for (var i = 1; i < rows.length; i++) {
          final row = rows[i];
          final rowData = <String, dynamic>{};

          for (var j = 0; j < headers.length; j++) {
            rowData[headers[j]] = row[j]?.value;
          }

          chunk.add(rowData);

          if (chunk.length == chunkSize) {
            yield chunk;
            chunk = [];
          }
        }

        if (chunk.isNotEmpty) {
          yield chunk;
        }
      }
    } catch (e) {
      debugPrint("Error al leer el archivo Excel: $e");
    }
  }
}

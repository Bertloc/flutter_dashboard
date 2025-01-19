import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CompliancePieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CompliancePieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtrar solo los datos con valor mayor a cero
    final filteredData =
        data.where((item) => (item['value'] as double) > 0).toList();

    if (filteredData.isEmpty) {
      return const Center(
        child: Text(
          "No hay datos para mostrar",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Calcular el total y normalizar los valores
    final total = filteredData.fold(
        0.0, (sum, item) => sum + (item['value'] as double));
    final normalizedData = filteredData
        .map((item) => {
              ...item,
              'value': ((item['value'] as double) / total * 100).toStringAsFixed(2)
            })
        .toList();

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título y descripción
            const Text(
              "Cumplimiento General",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Representación del cumplimiento de los pedidos con base en su estado.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),

            // Gráfico
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: normalizedData.map((item) {
                    final double value = double.parse(item['value']);
                    final String label = item['label'] ?? 'Desconocido';
                    return PieChartSectionData(
                      value: value,
                      title: "${value.toStringAsFixed(1)}%",
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      radius: 100,
                      color: _getColorForLabel(label),
                    );
                  }).toList(),
                  sectionsSpace: 2.0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),

            // Leyenda
            const SizedBox(height: 16.0),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.0,
              children: normalizedData.map((item) {
                final String label = item['label'] ?? 'Desconocido';
                final double value = double.parse(item['value']);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getColorForLabel(label),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$label: ${value.toStringAsFixed(1)}%",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Obtener colores dinámicos según el label
  Color _getColorForLabel(String label) {
    switch (label) {
      case 'Despachado':
        return Colors.green;
      case 'Programado':
        return Colors.blue;
      case 'Confirmado':
        return Colors.orange;
      case 'No confirmado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

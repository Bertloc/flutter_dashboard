import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductCategorySummaryPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ProductCategorySummaryPieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No hay datos para mostrar"));
    }

    // Total de valores para calcular porcentajes
    final double total = data.fold(0.0, (sum, item) => sum + (item['value'] as num).toDouble());

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resumen por Categoría de Producto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: data.map((entry) {
                    final double value = (entry['value'] as num).toDouble();
                    final String label = entry['label'] as String;
                    final double percentage = (value / total) * 100;

                    return PieChartSectionData(
                      value: value,
                      title: '${percentage.toStringAsFixed(1)}%',
                      radius: 100,
                      titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      color: _getColorForLabel(label),
                    );
                  }).toList(),
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de etiquetas
            Column(
              children: data.map((entry) {
                final String label = entry['label'] as String;
                final Color color = _getColorForLabel(label);
                return Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Asignar colores a las etiquetas de las categorías
  Color _getColorForLabel(String label) {
    final colors = [
      Colors.purple,
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.teal,
    ];
    return colors[label.hashCode % colors.length];
  }
}

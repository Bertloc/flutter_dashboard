import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProductCategoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ProductCategoryWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resumen por Categoría de Producto",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: data.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay datos disponibles",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: _generateBarGroups(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 10,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString());
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < data.length) {
                                  final label = data[value.toInt()]["label"] ?? "Sin etiqueta";
                                  return Text(
                                    label,
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const Text("");
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final toY = (item["Cantida Pedido"] ?? 0).toDouble();
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: toY,
            color: Colors.green,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}

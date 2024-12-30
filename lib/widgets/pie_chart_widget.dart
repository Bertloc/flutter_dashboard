import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PieChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Cumplimiento por Estatus",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Espaciado adicional entre título y gráfico
            AspectRatio(
              aspectRatio: 1.2,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  sections: _getSections(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    final total = data.fold<num>(0, (sum, item) => sum + (item['Cantida Pedido'] as num));

    return List.generate(data.length, (index) {
      final item = data[index];
      final value = item['Cantida Pedido'] as num;
      final percentage = (value / total) * 100;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: value.toDouble(),
        title: percentage > 5 ? "${percentage.toStringAsFixed(1)}%" : "",
        radius: 80,
        titleStyle: TextStyle(
          fontSize: percentage > 5 ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: percentage <= 5
            ? Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              )
            : null,
      );
    });
  }

  Widget buildLegend() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4), // Espaciado entre elementos de la leyenda
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  "${item['Estatus Pedido']} (${(item['Cantida Pedido'] as num).toStringAsFixed(0)})",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

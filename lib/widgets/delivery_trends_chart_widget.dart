import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DeliveryTrendsChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DeliveryTrendsChartWidget({Key? key, required this.data}) : super(key: key);

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
              "Tendencias de Entregas",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: _generateLineBars(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            final date = data[value.toInt()]["Fecha"];
                            return Text(
                              date != null ? date.toString() : "",
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> _generateLineBars() {
    return [
      LineChartBarData(
        spots: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final yValue = item["Cantidad entrega"];

          if (yValue != null && yValue is num) {
            return FlSpot(index.toDouble(), yValue.toDouble());
          }
          return FlSpot(index.toDouble(), 0); // Fallback para valores nulos
        }).toList(),
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        dotData: FlDotData(show: false),
      ),
    ];
  }
}

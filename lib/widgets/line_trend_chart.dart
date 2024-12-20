import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data; // Datos dinámicos

  const LineTrendChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 50),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < data.length) {
                    return Text(
                      data[value.toInt()]['Fecha'],
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (index) => FlSpot(
                  index.toDouble(),
                  data[index]['Entregado']?.toDouble() ?? 0.0,
                ),
              ),
              isCurved: true,
              dotData: FlDotData(show: true),
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}

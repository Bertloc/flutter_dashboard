import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const LineTrendChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spots = data
        .map((row) => FlSpot(
              data.indexOf(row).toDouble(),
              row['Volumen Entregado']?.toDouble() ?? 0.0,
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
              ),
              barWidth: 4,
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  try {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      return Text(data[index]['Fecha'] ?? '');
                    }
                  } catch (e) {
                    return const Text('');
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          maxY: data.isNotEmpty
              ? (data.map((row) => row['Volumen Entregado']?.toDouble() ?? 0.0).reduce((a, b) => a > b ? a : b) + 10)
              : 10,
          minY: 0,
        ),
      ),
    );
  }
}

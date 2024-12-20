import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> data; // Datos dinámicos

  const DailyTrendChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Usar los primeros 10 valores de "Fecha" como etiquetas
                  return Text(
                    data[value.toInt()]['Fecha'],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, interval: 50),
            ),
          ),
          barGroups: List.generate(
            data.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: data[index]['Entregado'].toDouble(),
                  color: Colors.deepPurple.shade400,
                  borderRadius: BorderRadius.circular(4),
                  width: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

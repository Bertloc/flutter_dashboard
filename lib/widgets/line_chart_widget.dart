import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const LineChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Preparar los datos para el gráfico
    final List<FlSpot> spots = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final value = entry.value['Cantidad entrega'] ?? 0.0;
      return FlSpot(index, value.toDouble());
    }).toList();

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox.shrink();
                  final date = data[index]['Fecha Entrega'] ?? '';
                  return Text(
                    date,
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border.symmetric(
              horizontal: BorderSide(color: Colors.grey),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

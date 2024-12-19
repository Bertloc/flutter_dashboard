import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyTrendChart extends StatelessWidget {
  const DailyTrendChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          backgroundColor: Colors.grey.shade200,
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    "01-nov", "02-nov", "04-nov", "05-nov", "06-nov",
                    "07-nov", "08-nov", "09-nov", "11-nov", "12-nov"
                  ];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 50,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          barGroups: _buildBars(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBars() {
    final data = [88, 80, 136, 254, 193, 91, 82, 94, 156, 20];
    return List.generate(
      data.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].toDouble(),
            color: Colors.deepPurple.shade400,
            borderRadius: BorderRadius.circular(4),
            width: 14,
          ),
        ],
      ),
    );
  }
}

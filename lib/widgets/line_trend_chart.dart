import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineTrendChart extends StatelessWidget {
  const LineTrendChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    "01-nov", "02-nov", "04-nov", "05-nov", "06-nov",
                    "07-nov", "08-nov", "09-nov", "11-nov", "12-nov"
                  ];
                  return Text(days[value.toInt()]);
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 88),
                FlSpot(1, 80),
                FlSpot(2, 136),
                FlSpot(3, 254),
                FlSpot(4, 193),
                FlSpot(5, 91),
                FlSpot(6, 82),
                FlSpot(7, 94),
                FlSpot(8, 156),
                FlSpot(9, 20),
              ],
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 4,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}

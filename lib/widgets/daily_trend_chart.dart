import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyTrendChart extends StatelessWidget {
  final Map<String, double> groupedData;

  const DailyTrendChart({Key? key, required this.groupedData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedDates = groupedData.keys.toList()..sort();
    final spots = sortedDates
        .map((date) => FlSpot(
              _convertDateToDouble(date),
              groupedData[date] ?? 0.0,
            ))
        .toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tendencia Diaria',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              _convertDoubleToDate(value),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _convertDateToDouble(String date) {
    final parsedDate = DateTime.tryParse(date);
    return parsedDate != null ? parsedDate.millisecondsSinceEpoch.toDouble() : 0.0;
  }

  String _convertDoubleToDate(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return "${date.day}/${date.month}";
  }
}

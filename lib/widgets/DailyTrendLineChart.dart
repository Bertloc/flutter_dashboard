import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyTrendLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DailyTrendLineChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No hay datos para mostrar"));
    }

    // Convertir datos para el gráfico
    List<FlSpot> spots = data
        .map((entry) => FlSpot(
              DateTime.parse(entry['x']).millisecondsSinceEpoch.toDouble(),
              entry['y']?.toDouble() ?? 0.0,
            ))
        .toList();

    // Obtener los rangos del eje X para mostrar las fechas correctamente
    final DateTime startDate =
        DateTime.fromMillisecondsSinceEpoch(spots.first.x.toInt());
    final DateTime endDate =
        DateTime.fromMillisecondsSinceEpoch(spots.last.x.toInt());

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tendencia Diaria",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue, // Corrección del parámetro
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.blueAccent.withOpacity(0.1),
                          ],
                        ),
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (spots.last.x - spots.first.x) / 5,
                        getTitlesWidget: (value, meta) {
                          final date =
                              DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          return Text(
                            "${date.day}/${date.month}",
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border.symmetric(
                      horizontal: BorderSide(color: Colors.black26),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

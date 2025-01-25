import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailySummaryLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DailySummaryLineChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verificar si los datos están vacíos
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No hay datos para mostrar",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // Convertir los datos a FlSpot con validación robusta
    final spots = data
        .where((entry) =>
            entry['x'] != null &&
            entry['y'] != null &&
            entry['x'] is String &&
            entry['y'] is num &&
            DateTime.tryParse(entry['x']) != null &&
            (entry['y'] as num).isFinite) // Filtrar NaN e Infinity
        .map((entry) => FlSpot(
              DateTime.parse(entry['x']).millisecondsSinceEpoch.toDouble(),
              (entry['y'] as num).toDouble(),
            ))
        .toList();

    // Manejar caso donde no hay puntos válidos
    if (spots.isEmpty) {
      return const Center(
        child: Text(
          "No se generaron puntos válidos para la gráfica",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // Construir el gráfico
    return SizedBox(
      height: 300, // Define un tamaño fijo
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  try {
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Text(
                      "${date.day}/${date.month}",
                      style: const TextStyle(fontSize: 10),
                    );
                  } catch (e) {
                    return const Text('');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

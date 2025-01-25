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

    // Convertir los datos a FlSpot con validación de fechas y valores
    final spots = data
        .where((entry) =>
            entry['x'] != null &&
            entry['y'] != null &&
            DateTime.tryParse(entry['x']) != null) // Validar formato de fecha
        .map((entry) {
      final x = DateTime.parse(entry['x']).millisecondsSinceEpoch.toDouble();
      final y = (entry['y'] as num?)?.toDouble() ?? 0.0;
      return FlSpot(x, y.isFinite ? y : 0.0); // Evitar valores NaN o infinitos
    }).toList();

    if (spots.isEmpty) {
      return const Center(
        child: Text(
          "No se generaron puntos válidos para la gráfica",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // Construir el gráfico
    return LineChart(
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
                  return const Text("", style: TextStyle(fontSize: 10));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

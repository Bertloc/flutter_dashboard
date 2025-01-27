import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyDeliveryReportLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DailyDeliveryReportLineChart({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No hay datos para mostrar"));
    }

    // Crear un mapa de fechas a índices
    final dateMap = <String, int>{};
    int currentIndex = 0;
    for (var entry in data) {
      final date = entry['Fecha'];
      if (date != null && !dateMap.containsKey(date)) {
        dateMap[date] = currentIndex++;
      }
    }

    // Generar los puntos (spots) para el gráfico
    List<FlSpot> spots = [];
    for (var entry in data) {
      try {
        if (entry['Fecha'] != null && entry['Total Entregado'] != null) {
          final x = dateMap[entry['Fecha']]!.toDouble(); // Índice de la fecha
          final y = (entry['Total Entregado'] as num).toDouble();
          spots.add(FlSpot(x, y));
        }
      } catch (e) {
        debugPrint("Error procesando entrada: $entry, Error: $e");
      }
    }

    if (spots.isEmpty) {
      return const Center(child: Text("No hay datos válidos para mostrar"));
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reporte Diario de Entregas",
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
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.blueAccent],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.blueAccent.withOpacity(0.3),
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
                        getTitlesWidget: (value, meta) {
                          // Obtener la fecha correspondiente al índice
                          final date = dateMap.entries
                              .firstWhere((element) =>
                                  element.value.toDouble() == value)
                              .key;
                          return Text(
                            date, // Mostrar la fecha como etiqueta
                            style: const TextStyle(fontSize: 10),
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

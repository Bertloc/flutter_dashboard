import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyDeliveryReportWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DailyDeliveryReportWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No hay datos disponibles para el reporte diario de entrega",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reporte Diario de Entrega",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _generateBarGroups(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Text(
                              data[value.toInt()]['Producto'] ?? "Sin etiqueta",
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text("", style: TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final totalEntregado = (item['Total Entregado'] ?? 0).toDouble();
      final totalViajes = (item['Total Viajes'] ?? 0).toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: totalEntregado,
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: totalViajes,
            color: Colors.green,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}

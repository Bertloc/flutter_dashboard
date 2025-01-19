import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PendingOrdersBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PendingOrdersBarChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No hay datos para mostrar"));
    }

    // Extraer los valores para el gráfico
    final List<String> materials = data.map((entry) => entry['Material'] as String).toList();
    final List<double> values = data.map((entry) => (entry['Cantidad confirmada'] as num).toDouble()).toList();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pedidos Pendientes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(materials.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: values[index],
                          color: Colors.redAccent,
                          width: 16,
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= materials.length) return const SizedBox.shrink();
                          return Text(
                            materials[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 10),
                        ),
                        reservedSize: 40,
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
                  alignment: BarChartAlignment.spaceAround,
                  maxY: values.reduce((a, b) => a > b ? a : b) * 1.2, // Incrementar para margen
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DeliveryReportBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const DeliveryReportBarChart({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No hay datos para mostrar"));
    }

    // Agrupar datos por fecha y preparar para las barras apiladas
    final groupedData = _groupDataByDate(data);

    if (groupedData.isEmpty) {
      return const Center(child: Text("No hay datos válidos para mostrar"));
    }

    // Crear el índice para las fechas ordenadas
    final sortedDates = groupedData.keys.toList()..sort();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reporte de Entrega",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barGroups: sortedDates.map((date) {
                    final index = sortedDates.indexOf(date);
                    return BarChartGroupData(
                      x: index,
                      barRods: groupedData[date]!
                          .map((entry) => BarChartRodData(
                                toY: entry['value'] as double,
                                color: _getColorForLabel(entry['label']),
                                width: 16,
                              ))
                          .toList(),
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final dateIndex = value.toInt();
                          if (dateIndex < 0 ||
                              dateIndex >= sortedDates.length) {
                            return const SizedBox.shrink();
                          }
                          final date = sortedDates[dateIndex];
                          final parsedDate = DateTime.parse(date);
                          return Text(
                            "${parsedDate.day}/${parsedDate.month}",
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
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de etiquetas
            Column(
              children: _getUniqueLabels(data).map((label) {
                final color = _getColorForLabel(label);
                return Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: color,
                    ),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Función para agrupar datos por fecha
  Map<String, List<Map<String, dynamic>>> _groupDataByDate(
      List<Map<String, dynamic>> data) {
    final Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (final entry in data) {
      final date = entry['Fecha Entrega'] as String?;
      final label = entry['Material']?.toString(); // Convertir a String
      final value = (entry['Cantidad entrega'] as num?)?.toDouble();

      // Validar que los datos no sean nulos antes de procesarlos
      if (date != null && label != null && value != null) {
        if (!groupedData.containsKey(date)) {
          groupedData[date] = [];
        }
        groupedData[date]!.add({'label': label, 'value': value});
      }
    }
    return groupedData;
  }

  // Obtener etiquetas únicas
  List<String> _getUniqueLabels(List<Map<String, dynamic>> data) {
    return data
        .map((entry) => entry['Material']?.toString())
        .where((label) => label != null)
        .cast<String>()
        .toSet()
        .toList();
  }

  // Asignar colores a las etiquetas
  Color _getColorForLabel(String label) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.yellow,
    ];
    return colors[label.hashCode % colors.length];
  }
}

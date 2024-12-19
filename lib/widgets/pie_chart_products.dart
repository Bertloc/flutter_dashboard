import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartProducts extends StatelessWidget {
  const PieChartProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.5,
          child: PieChart(
            PieChartData(
              sections: _buildSections(),
              centerSpaceRadius: 40,
              sectionsSpace: 4,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      _buildSection(10, "Tolteca 25Kg", Colors.blueAccent),
      _buildSection(5, "Mortero 25Kg", Colors.greenAccent),
      _buildSection(5, "Multiplast 40Kg", Colors.orangeAccent),
      _buildSection(20, "Gris CPC", Colors.purpleAccent),
    ];
  }

  PieChartSectionData _buildSection(double value, String title, Color color) {
    return PieChartSectionData(
      value: value,
      color: color,
      title: "$value TN",
      radius: 80,
      titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _buildLegendRow("Tolteca 25Kg", Colors.blueAccent),
        _buildLegendRow("Mortero 25Kg", Colors.greenAccent),
        _buildLegendRow("Multiplast 40Kg", Colors.orangeAccent),
        _buildLegendRow("Gris CPC", Colors.purpleAccent),
      ],
    );
  }

  Widget _buildLegendRow(String title, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}

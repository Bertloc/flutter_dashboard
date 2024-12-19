import 'package:flutter/material.dart';
import '../widgets/daily_trend_chart.dart';
import '../widgets/line_trend_chart.dart';
import '../widgets/info_table.dart';
import '../widgets/pie_chart_products.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Interactivo")),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 20),
            Text("Cumplimiento Diario", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DailyTrendChart(),
            SizedBox(height: 20),
            Text("Tendencia de Entregas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            LineTrendChart(),
            SizedBox(height: 20),
            Text("Distribución de Productos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            PieChartProducts(),
            SizedBox(height: 20),
            Text("Resumen de Información", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            InfoTable(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SummaryTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const SummaryTableWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tabla de Resumen Diario",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300, // Ajustar según el diseño
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Fecha")),
                    DataColumn(label: Text("Cantidad Pedido")),
                    DataColumn(label: Text("Cantidad Entrega")),
                    DataColumn(label: Text("% Aprovechamiento")),
                  ],
                  rows: data.map((row) {
                    return DataRow(cells: [
                      DataCell(Text(row["Fecha Entrega"])),
                      DataCell(Text(row["Cantida Pedido"].toString())),
                      DataCell(Text(row["Cantidad entrega"].toString())),
                      DataCell(Text("${row["% Aprovechamiento"]}%")),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


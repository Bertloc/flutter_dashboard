import 'package:flutter/material.dart';

class InfoTable extends StatelessWidget {
  const InfoTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.deepPurple.shade200),
        dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
        columns: const [
          DataColumn(label: Text("Fecha", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Objetivo Diario", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Volumen Entregado", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Aprovechamiento (%)", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: _buildRows(),
      ),
    );
  }

  List<DataRow> _buildRows() {
    final data = [
      {"Fecha": "01-nov", "Objetivo": "143.5", "Entregado": "68", "Aprovechamiento": "61%"},
      {"Fecha": "02-nov", "Objetivo": "143.5", "Entregado": "160", "Aprovechamiento": "56%"},
      {"Fecha": "04-nov", "Objetivo": "143.5", "Entregado": "176", "Aprovechamiento": "95%"},
    ];
    return data.map((row) {
      return DataRow(
        cells: [
          DataCell(Text(row["Fecha"]!)),
          DataCell(Text(row["Objetivo"]!)),
          DataCell(Text(row["Entregado"]!)),
          DataCell(Text(row["Aprovechamiento"]!)),
        ],
      );
    }).toList();
  }
}

import 'package:flutter/material.dart';

class PendingOrdersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PendingOrdersWidget({Key? key, required this.data}) : super(key: key);

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
              "Pedidos Pendientes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            data.isEmpty
                ? const Center(
                    child: Text(
                      "No hay pedidos pendientes.",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return ListTile(
                          title: Text("Material: ${item['Material']}"),
                          subtitle: Text(
                            "Cantidad Confirmada: ${item['Cantidad confirmada']}",
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


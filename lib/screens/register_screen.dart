import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de Nombre
            TextField(
              decoration: const InputDecoration(
                labelText: "Nombre Completo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Campo de Correo
            TextField(
              decoration: const InputDecoration(
                labelText: "Correo Electrónico",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Campo de Contraseña
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Botón de Registro
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: const Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}


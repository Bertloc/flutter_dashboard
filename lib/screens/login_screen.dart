import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesión"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de Correo Electrónico
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
            // Botón de Iniciar Sesión
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text("Iniciar Sesión"),
            ),
            const SizedBox(height: 10),
            // Botón de Registro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("¿No tienes cuenta? Regístrate"),
            ),
          ],
        ),
      ),
    );
  }
}


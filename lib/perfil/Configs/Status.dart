// Status.dart
import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  // Função que simula o status da conta. Ajuste conforme a lógica do seu aplicativo.
  bool _isAccountActive() {
    // Simulação do status da conta; altere conforme necessário.
    return true; // Defina como false para simular uma conta desativada.
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = _isAccountActive();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status da Conta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? Colors.green : Colors.red,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              isActive ? 'Conta Ativa' : 'Conta Desativada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isActive
                  ? 'Sua conta está atualmente ativa e em pleno funcionamento.'
                  : 'Sua conta está desativada. Entre em contato com o suporte para mais informações.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

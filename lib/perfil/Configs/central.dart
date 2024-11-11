// privacy_center_page.dart
import 'package:flutter/material.dart';

class PrivacyCenterPage extends StatelessWidget {
  const PrivacyCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Privacidade'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior (PerfilPage)
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurações de Privacidade',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aqui você pode gerenciar as configurações de privacidade do seu perfil.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Adicione mais opções de configurações de privacidade conforme necessário
            ListTile(
              title: const Text('Visibilidade do Perfil'),
              trailing: Switch(
                value: true, // Simula a visibilidade do perfil
                onChanged: (bool value) {
                  // Aqui você pode adicionar a lógica para mudar a visibilidade do perfil
                },
              ),
            ),
            ListTile(
              title: const Text('Ativar Notificações'),
              trailing: Switch(
                value: true, // Simula o estado de notificações
                onChanged: (bool value) {
                  // Lógica para ativar ou desativar notificações
                },
              ),
            ),
            // Adicione mais configurações conforme necessário
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  // Removendo o 'const' aqui para evitar o comportamento de "const"
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Como posso ajudar?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Como funciona a doação de animais?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'No nosso aplicativo, você pode buscar por animais disponíveis para adoção, ou cadastrar o seu animal para doação.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Como posso modificar meu perfil?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Acesse a página de perfil e toque na foto para alterar sua imagem de perfil. Você também pode editar as informações do seu perfil.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Como posso entrar em contato com o dono do animal?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Você pode enviar uma mensagem diretamente pelo post do animal de interesse para iniciar uma conversa.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '4. Preciso de ajuda com mais questões?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Se precisar de mais ajuda, entre em contato conosco através da central de atendimento ou visite nosso site.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação de entrar em contato, redirecionando ou acionando outro recurso
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Fale Conosco'),
                      content: const Text(
                        'Entre em contato com nossa central de atendimento através do número (XX) XXXX-XXXX.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fechar o diálogo
                          },
                          child: const Text('Fechar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Fale com a gente'),
            ),
          ],
        ),
      ),
    );
  }
}

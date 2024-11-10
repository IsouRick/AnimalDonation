import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String ownerName;

  ChatPage({required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat com $ownerName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Exemplo de 10 mensagens
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Mensagem ${index + 1}'),
                    subtitle: Text('Texto da mensagem aqui...'),
                  );
                },
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Digite uma mensagem...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Lógica para enviar mensagem
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

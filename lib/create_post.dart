import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Importando o Firebase Database
import 'package:firebase_auth/firebase_auth.dart'; // Importando o Firebase Auth

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref('posts');

  // Função para salvar o post no Firebase
  void _savePost() async {
    final imageUrl = _imageController.text.trim();
    final description = _descriptionController.text.trim();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (imageUrl.isEmpty || description.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos e faça login!')),
      );
      return;
    }

    try {
      // Salva o post no Firebase
      final postRef = databaseRef.push();
      await postRef.set({
        'imageUrl': imageUrl,
        'description': description,
        'userId': userId,
        'likes': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post criado com sucesso!')),
      );

      // Voltar para a HomePage após criar o post
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar o post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,  // Cor de fundo mais suave
      appBar: AppBar(
        title: const Text('Criar Novo Post'),
        backgroundColor: Colors.teal.shade700,  // Tom mais forte para o AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'URL da Imagem',
                labelStyle: TextStyle(color: Colors.black),  // Cor da label
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),  // Cor da borda
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: Colors.black),  // Cor da label
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),  // Cor da borda
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePost,
              child: const Text('Salvar Post'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: Colors.teal.shade600,  // Cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
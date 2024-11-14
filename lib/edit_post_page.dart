import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditPostPage extends StatefulWidget {
  final String postId;
  final String currentDescription;
  final String currentImageUrl;

  const EditPostPage({
    super.key,
    required this.postId,
    required this.currentDescription,
    required this.currentImageUrl,
  });

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.currentDescription;
    _imageUrlController.text = widget.currentImageUrl;
  }

  // Função para salvar as alterações no Firebase
  void _saveChanges() async {
    final postRef = FirebaseDatabase.instance.ref('posts/${widget.postId}');
    
    await postRef.update({
      'description': _descriptionController.text,
      'imageUrl': _imageUrlController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post atualizado com sucesso!')),
    );

    // Retorna para a página principal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Post'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL da Imagem'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
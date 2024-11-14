import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AnimalDetailPage extends StatelessWidget {
  final Map<String, dynamic> animal;

  AnimalDetailPage({required this.animal});

  Future<void> _deleteAnimal(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && userId == animal['userId']) {
      try {
        await FirebaseDatabase.instance.ref('animals/${animal['animalId']}').remove();

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal excluído com sucesso!')),
        );
      } catch (e) {
        print('Erro ao excluir animal: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir animal.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não tem permissão para excluir este animal.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(animal['name'] ?? 'Detalhes do Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: animal['imageUrl'] != null
                          ? Image.network(
                              animal['imageUrl'],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.pets, size: 100.0),
                    ),
                    const SizedBox(height: 16.0),

                    Text(
                      'Nome: ${animal['name'] ?? 'Nome desconhecido'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    Text(
                      'Raça: ${animal['breed'] ?? 'Desconhecida'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    Text(
                      'Sexo: ${animal['sex'] ?? 'Desconhecido'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    Text(
                      'Tipo: ${animal['type'] ?? 'Desconhecido'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    
                    Text(
                      'Localização: ${animal['location'] ?? 'Desconhecida'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    Text(
                      'Descrição: ${animal['description'] ?? 'Sem descrição'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),

            if (userId != null && userId == animal['userId'])
              Center(
                child: ElevatedButton(
                  onPressed: () => _deleteAnimal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Excluir Animal'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

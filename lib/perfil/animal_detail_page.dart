import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AnimalDetailPage extends StatelessWidget {
  final Map<String, dynamic> animal; // Dados do animal

  AnimalDetailPage({required this.animal});

  Future<void> _deleteAnimal(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && userId == animal['userId']) {
      try {
        // Excluindo o animal da base de dados
        await FirebaseDatabase.instance.ref('animals/${animal['animalId']}').remove();

        // Excluindo o animal da lista local após remoção na base de dados
        Navigator.pop(context); // Fechar a página de detalhes após a exclusão
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
      // Caso o usuário não tenha permissão para excluir
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
                    // Exibir imagem do animal centralizada
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

                    // Nome do animal com estilo
                    Text(
                      'Nome: ${animal['name'] ?? 'Nome desconhecido'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Raça do animal
                    Text(
                      'Raça: ${animal['breed'] ?? 'Desconhecida'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    // Sexo do animal
                    Text(
                      'Sexo: ${animal['sex'] ?? 'Desconhecido'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    // Tipo do animal
                    Text(
                      'Tipo: ${animal['type'] ?? 'Desconhecido'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    // Localização
                    Text(
                      'Localização: ${animal['location'] ?? 'Desconhecida'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),

                    // Descrição do animal
                    Text(
                      'Descrição: ${animal['description'] ?? 'Sem descrição'}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),

            // Botão de exclusão, visível apenas se o usuário for o criador do animal
            if (userId != null && userId == animal['userId'])
              Center(
                child: ElevatedButton(
                  onPressed: () => _deleteAnimal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Cor de fundo do botão
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

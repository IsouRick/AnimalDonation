import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AnimalRegistrationPage extends StatefulWidget {
  const AnimalRegistrationPage({super.key});

  @override
  _AnimalRegistrationPageState createState() => _AnimalRegistrationPageState();
}

class _AnimalRegistrationPageState extends State<AnimalRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String _imageUrl = '';

  Future<void> _registerAnimal() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final animalRef = FirebaseDatabase.instance.ref('animals').push();
      try {
        await animalRef.set({
          'name': _nameController.text,
          'location': _locationController.text,
          'description': _descriptionController.text,
          'sex': _sexController.text,
          'type': _typeController.text,
          'breed': _breedController.text,
          'imageUrl': _imageUrlController.text,
          'userId': userId,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Animal cadastrado com sucesso!')),
        );
        _nameController.clear();
        _locationController.clear();
        _descriptionController.clear();
        _sexController.clear();
        _typeController.clear();
        _breedController.clear();
        _imageUrlController.clear();
        setState(() {
          _imageUrl = '';
        });
      } catch (e) {
        print("Erro ao cadastrar animal: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao cadastrar animal. Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Cadastro de Animal'),
        centerTitle: true,
        actions: [
          
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _registerAnimal,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                backgroundImage:
                    _imageUrl.isEmpty ? null : NetworkImage(_imageUrl),
                child: _imageUrl.isEmpty
                    ? const Icon(Icons.pets, size: 60, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Animal',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Localidade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _sexController,
                decoration: const InputDecoration(
                  labelText: 'Sexo (Macho/Fêmea)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo (Cachorro, Gato, etc.)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Raça',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(),
                ),
                onChanged: (url) {
                  setState(() {
                    _imageUrl = url;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
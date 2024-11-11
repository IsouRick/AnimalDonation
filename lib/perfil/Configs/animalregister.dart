import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterAnimal extends StatefulWidget {
  const RegisterAnimal({super.key});

  @override
  _RegisterAnimalState createState() => _RegisterAnimalState();
}

class _RegisterAnimalState extends State<RegisterAnimal> {
  final _formKey = GlobalKey<FormState>();
  File? _animalImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Função para escolher a imagem do animal
  Future<void> _pickAnimalImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _animalImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cadastrar Animal',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Foto do Animal
                GestureDetector(
                  onTap: _pickAnimalImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _animalImage != null
                        ? FileImage(_animalImage!)
                        : const AssetImage('assets/images/logo.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),

                // Nome do Animal
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Animal',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do animal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Tipo do Animal
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo (Ex: Cão, Gato, etc.)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tipo de animal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Raça do Animal
                TextFormField(
                  controller: _breedController,
                  decoration: const InputDecoration(
                    labelText: 'Raça',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a raça do animal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Idade do Animal
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Idade (em anos)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a idade do animal';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Descrição do Animal
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 30),

                // Botão de envio
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Processar os dados
                      // Aqui você pode salvar as informações no banco de dados ou enviar para o backend
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Animal Cadastrado!')),
                      );
                    }
                  },
                  child: const Text('Cadastrar Animal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:doacao_animal/perfil/perfil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConfiguracaoPage extends StatefulWidget {
  const ConfiguracaoPage({super.key});

  @override
  _ConfiguracaoPageState createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configurações salvas com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PerfilPage()), // Navegar para a tela de perfil
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildProfileForm(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _profileImage != null
              ? FileImage(_profileImage!)
              : const AssetImage('assets/images/profile.jpg') as ImageProvider,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickProfileImage,
          child: const Text('Alterar Foto de Perfil'),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nome',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Digite seu nome',
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Biografia',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        TextField(
          controller: _bioController,
          decoration: const InputDecoration(
            hintText: 'Escreva algo sobre você',
          ),
          maxLines: 4,
        ),
      ],
    );
  }
}

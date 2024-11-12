import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _profileImage;
  final TextEditingController _customReportController = TextEditingController();

  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildProfileBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildProfileStats(),
          const SizedBox(height: 20),
          _buildAnimalRegisterButton(),
          const SizedBox(height: 20),
          _buildPostsSection(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap:
              _pickProfileImage, 
          child: CircleAvatar(
            radius: 60,
            backgroundImage: _profileImage != null
                ? FileImage(_profileImage!)
                : const AssetImage('assets/images/profile.jpg')
                    as ImageProvider,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Nome do Usuário',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '@usuario1',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem('Seguidores', '150'),
        const SizedBox(width: 30),
        _buildStatItem('Seguindo', '200'),
        const SizedBox(width: 30),
        _buildStatItem('Posts', '30'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimalRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/perfilPage');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      child: const Text('Cadastrar Animal'),
    );
  }

  Widget _buildPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Posts Recentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 10),
        _buildPostItem('assets/images/fotoperfilmulher.jpg'),
        const SizedBox(height: 10),
        _buildPostItem('assets/images/fotoperfilmulher.jpg'),
      ],
    );
  }

  Widget _buildPostItem(String imagePath) {
    return GestureDetector(
      onTap: () {
        _showPostPreviewDialog(imagePath);
      },
      child: Card(
        color: Colors.teal.shade50,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  void _showPostPreviewDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Pré-Visualização do Post',
            style: TextStyle(color: Colors.teal),
          ),
          content: Image.asset(imagePath),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            iconSize: 24.0, 
            onSelected: (item) {
              switch (item) {
                case 0:
                  Navigator.pushNamed(context, '/registeredAnimals');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/configuracao');
                  break;
                case 2:
                  _showLogoutDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 6.0), 
                  child: Row(
                    children: [
                      Icon(Icons.pets, color: Colors.brown),
                      SizedBox(width: 10),
                      Text('Animais Cadastrados'),
                    ],
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 6.0),
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Configurações'),
                    ],
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 6.0),
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildProfileBody(),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Você deseja realmente sair?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}

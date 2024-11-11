import 'dart:io';
import 'package:doacao_animal/perfil/Configs/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _profileImage;

  // Função para escolher a imagem de perfil
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

  Widget _buildProfileBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildProfileStats(),
          const SizedBox(height: 20),
          _buildAnimalRegisterButton(), // Botão de cadastrar animal
          const SizedBox(height: 20),
          _buildPostsSection(),
        ],
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
        const Text(
          'Nome do Usuário',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '@usuario1',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
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
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Botão de Cadastrar Animal
  Widget _buildAnimalRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context,
            '/registerAnimal'); // Redireciona para a página de cadastro de animais
      },
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
          title: const Text('Pré-Visualização do Post'),
          content: Image.asset(imagePath),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Perfil',
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
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onSelected: (item) {
              switch (item) {
                case 0:
                  _showRegisteredAnimalsPage();
                  break;
                case 1:
                  _showMessagesDialog();
                  break;
                case 2:
                  _showAccountStatusDialog();

                  break;
                case 3:
                  _showPrivacyCenterDialog();

                  break;
                case 4:
                  _showSettingsDialog();

                  break;
                case 5:
                  _showBlockedDialog();

                  break;
                case 6:
                  _showHelpDialog();

                  break;
                case 7:
                  _showLogoutDialog();

                  break;
                case 8:
                  _showAboutDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: const [
                    Icon(Icons.pets, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Animais Cadastrados'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: const [
                    Icon(Icons.message, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Mensagens'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: const [
                    Icon(Icons.account_circle, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Status da Conta'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: const [
                    Icon(Icons.security, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Central de Privacidade'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Row(
                  children: const [
                    Icon(Icons.settings, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Configurações'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Row(
                  children: const [
                    Icon(Icons.block, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Bloqueados'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 6,
                child: Row(
                  children: const [
                    Icon(Icons.help, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Ajuda'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 7,
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Logout'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 8,
                child: Row(
                  children: const [
                    Icon(Icons.info, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Sobre'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildProfileBody(),
    );
  }

  void _showSettingsDialog() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ConfiguracaoPage()),
    );
  }

  void _showHelpDialog() {
    Navigator.pushNamed(context, '/help');
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
                Navigator.pushReplacementNamed(
                    context, '/login'); // Redireciona para a tela de login
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyCenterDialog() {
    Navigator.pushNamed(context, '/PrivacyCenterPage');
  }

  void _showAccountStatusDialog() {
    Navigator.pushNamed(context, '/status');
  }

  void _showBlockedDialog() {
    Navigator.pushNamed(context, '/blocked');
  }

  void _showAboutDialog() {
    Navigator.pushNamed(context, '/about');
  }

  void _showMessagesDialog() {
    Navigator.pushNamed(context, '/messages');
  }

  void _showRegisteredAnimalsPage() {
    Navigator.pushNamed(context, '/registeredAnimals');
  }
}

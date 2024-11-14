import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _profilePictureUrlController =
      TextEditingController();

  String _username = '';
  String _profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot =
          await FirebaseDatabase.instance.ref('users/$userId').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _username = data['username'] ?? 'Usuário sem nome';
          _profilePictureUrl = data['profilePictureUrl'] ?? '';
          _usernameController.text = _username;
          _profilePictureUrlController.text = _profilePictureUrl;
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await FirebaseDatabase.instance.ref('users/$userId').update({
          'username': _usernameController.text,
          'profilePictureUrl': _profilePictureUrlController.text,
        });
        setState(() {
          _username = _usernameController.text;
          _profilePictureUrl = _profilePictureUrlController.text;
        });
      } catch (e) {
        print("Error updating user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Configurações"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateUserData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exibição da foto de perfil a partir da URL
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                backgroundImage: _profilePictureUrl.isEmpty
                    ? null
                    : NetworkImage(_profilePictureUrl),
                child: _profilePictureUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 20),
              // Campo de texto para nome de usuário
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nome de Usuário",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Campo de texto para URL da foto de perfil
              TextField(
                controller: _profilePictureUrlController,
                decoration: const InputDecoration(
                  labelText: "URL da Foto de Perfil",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
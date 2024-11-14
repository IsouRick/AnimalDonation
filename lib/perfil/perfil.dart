import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String username = '';
  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchUserPosts();
  }

  Future<String?> _fetchProfilePictureUrl() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseDatabase.instance
          .ref("users/$userId/profilePictureUrl")
          .get();
      if (snapshot.exists) {
        return snapshot.value as String;
      }
    }
    return null;
  }

  Future<void> _fetchUsername() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot =
          await FirebaseDatabase.instance.ref("users/$userId/username").get();
      if (snapshot.exists) {
        setState(() {
          username = snapshot.value as String;
        });
      }
    }
  }

  Future<void> _fetchUserPosts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseDatabase.instance
          .ref("posts")
          .orderByChild("userId")
          .equalTo(userId)
          .get();

      if (snapshot.exists) {
        final postsData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          userPosts = postsData.values
              .map((post) => Map<String, dynamic>.from(post))
              .toList();

          // Ordena os posts do mais recente para o mais antigo
          userPosts.sort((a, b) {
            final timestampA = a['timestamp'];
            final timestampB = b['timestamp'];
            if (timestampA == null && timestampB == null) return 0;
            if (timestampA == null) return 1;
            if (timestampB == null) return -1;
            return timestampB.compareTo(timestampA);
          });
        });
      }
    }
  }

  Widget _buildProfileBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildAnimalRegisterButton(),
          const SizedBox(height: 20),
          _buildPostsGrid(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        FutureBuilder(
          future: _fetchProfilePictureUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                backgroundImage: NetworkImage(snapshot.data as String),
              );
            } else {
              return const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              );
            }
          },
        ),
        const SizedBox(height: 10),
        Text(
          username,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildPostsGrid() {
    return userPosts.isEmpty
        ? Center(child: Text("Nenhum post encontrado."))
        : SingleChildScrollView(
            // Adicionando o scroll
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0), // Um pequeno padding
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  return _buildPostItem(post);
                },
              ),
            ),
          );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exibe a imagem do post
          if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty)
            Image.network(
              post['imageUrl'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 8),
          // Exibe a descrição do post
          Text(
            post['description'] ?? 'Descrição não disponível',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/animalregister');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      child: const Text('Cadastrar Animal'),
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
                  Navigator.pushNamed(context, '/animalregister');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/configuracao');
                  break;
                case 2:
                  _logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                  value: 0, child: Text('Animais Cadastrados')),
              const PopupMenuItem<int>(value: 1, child: Text('Configurações')),
              const PopupMenuItem<int>(value: 2, child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: _buildProfileBody(),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Certifique-se de importar sua página de login
import 'edit_post_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'perfil/perfil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> feedItems = [];

  @override
  void initState() {
    super.initState();
    // Verificando login do usuário após o primeiro ciclo de build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  // Verifica o status de login do usuário
  void _checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Usuário não está logado, redireciona para a página de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      // Se estiver logado, escuta os posts em tempo real
      _listenForPosts();
    }
  }

  // Escuta os posts em tempo real
  void _listenForPosts() {
    final databaseReference = FirebaseDatabase.instance.ref('posts');
    databaseReference.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          feedItems.clear();
          Map<dynamic, dynamic> posts =
              event.snapshot.value as Map<dynamic, dynamic>;

          posts.forEach((key, value) {
            feedItems.add({
              'id': key,
              'imageUrl': value['imageUrl'],
              'description': value['description'],
              'userId': value['userId'],
              'likes': value['likes'] ?? [],
            });
          });
        });
      }
    });
  }

  // Função para curtir o post
  void _likePost(int index) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Faça login para curtir!')),
      );
      return;
    }

    final postId = feedItems[index]['id'];
    final postRef = FirebaseDatabase.instance.ref('posts/$postId');

    final snapshot = await postRef.get();
    if (snapshot.exists) {
      final post = snapshot.value as Map<dynamic, dynamic>;
      final likes = List<String>.from(post['likes'] ?? []);

      if (likes.contains(userId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você já curtiu esse post!')),
        );
        return;
      }

      likes.add(userId);
      await postRef.update({'likes': likes});

      setState(() {
        feedItems[index]['likes'] = likes;
      });
    }
  }

  // Função para obter o nome de usuário
  // Função para obter o nome de usuário
  Future<String> _getUserName(String userId) async {
    final userRef = FirebaseDatabase.instance.ref('users/$userId');
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      // Acessando o 'username' a partir do banco de dados
      var username = (snapshot.value as Map<dynamic, dynamic>)['username'];
      return username != null && username is String
          ? username
          : 'Usuário desconhecido';
    } else {
      return 'Usuário desconhecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a página de criação de posts
          Navigator.pushNamed(context, '/create-post');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.teal,
      elevation: 0,
      title: Row(
        children: [
          Text(
            'Sweet Home',
            style: GoogleFonts.lobster(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: FutureBuilder(
            future: _getUserProfilePicture(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    Icons.person,
                    color: Colors.teal,
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PerfilPage()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(snapshot.data!),
                    radius: 20,
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PerfilPage()),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      color: Colors.teal,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

// Função para obter a URL da foto de perfil do usuário
  Future<String?> _getUserProfilePicture() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userRef = FirebaseDatabase.instance.ref('users/$userId');
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        return (snapshot.value as Map<dynamic, dynamic>)['profilePictureUrl'];
      }
    }
    return null; // Retorna nulo se não houver URL de foto de perfil
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        final item = feedItems[index];
        return _buildFeedItem(item, index);
      },
    );
  }

  // Exibe o item do feed
  Widget _buildFeedItem(Map<String, dynamic> item, int index) {
    return FutureBuilder<String>(
      future: _getUserName(item['userId']), // Obter o nome do usuário
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userName = snapshot.data ?? 'Usuário desconhecido';
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;

        // Verifica se o usuário atual é o dono do post
        final isOwner = currentUserId == item['userId'];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exibindo o nome do usuário no topo da postagem
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userName, // Aqui exibe o nome do usuário
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Exibe a imagem
              if (item['imageUrl'] != null && item['imageUrl'].isNotEmpty)
                Image.network(
                  item['imageUrl'],
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image, size: 150);
                  },
                )
              else
                const Icon(Icons.image), // Ícone caso a imagem não exista
              // Exibe a descrição abaixo da imagem
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item['description'] ?? 'Descrição não disponível',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Exibe o número de curtidas
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      '${item['likes'].length} curtidas',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // Ícones para interações (curtir e comentar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.red,
                      onPressed: () => _likePost(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      color: Colors.blue,
                      onPressed: () {
                        // Lógica para o chat
                      },
                    ),
                    // Condicional para exibir as opções de editar e deletar
                    if (isOwner) ...[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navega para a página de edição, passando os dados do post
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPostPage(
                                postId: item['id'], // ID do post
                                currentDescription: item['description'] ??
                                    '', // Descrição atual
                                currentImageUrl: item['imageUrl'] ??
                                    '', // URL da imagem atual
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Lógica para deletar o post
                          _deletePost(item['id']);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Função para deletar o post
  void _deletePost(String postId) async {
    final postRef = FirebaseDatabase.instance.ref('posts/$postId');
    await postRef.remove();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post deletado com sucesso!')),
    );
  }
}
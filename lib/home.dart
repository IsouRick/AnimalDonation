import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    _fetchPosts();
  }

  // Função para buscar posts do Firebase
  Future<void> _fetchPosts() async {
    final databaseReference = FirebaseDatabase.instance.ref('posts');
    final snapshot = await databaseReference.get();

    if (snapshot.exists) {
      setState(() {
        feedItems.clear();
        Map<dynamic, dynamic> posts = snapshot.value as Map<dynamic, dynamic>;
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
    } else {
      print('No posts found');
    }
  }

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

      // Se o usuário já curtiu, não faz nada
      if (likes.contains(userId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você já curtiu esse post!')),
        );
        return;
      }

      // Adiciona o ID do usuário à lista de likes
      likes.add(userId);
      await postRef.update({'likes': likes});

      setState(() {
        feedItems[index]['likes'] = likes;
      });
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
      backgroundColor: Colors.white,
      elevation: 0,
    );
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

  Widget _buildFeedItem(Map<String, dynamic> item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  item['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          Image.network(
            item['imageUrl'],
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
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
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Lógica para compartilhar
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

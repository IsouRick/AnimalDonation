import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/login_page.dart';
import 'edit_post_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../perfil/perfil.dart';
import '../perfil/user_profile.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  void _checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      _listenForPosts();
    }
  }
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

  Future<String> _getUserName(String userId) async {
    final userRef = FirebaseDatabase.instance.ref('users/$userId');
    final snapshot = await userRef.get();
    if (snapshot.exists) {
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
      automaticallyImplyLeading: false,
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

  Future<String?> _getUserProfilePicture() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userRef = FirebaseDatabase.instance.ref('users/$userId');
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        return (snapshot.value as Map<dynamic, dynamic>)['profilePictureUrl'];
      }
    }
    return null;
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
    return FutureBuilder<String>(
      future: _getUserName(item['userId']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userName = snapshot.data ?? 'Usuário desconhecido';
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;

        final isOwner = currentUserId == item['userId'];

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
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isOwner) ...[
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPage(
                                userId: item[
                                    'userId'],
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  ],
                ),
              ),
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
                const Icon(Icons.image),
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
                    if (isOwner) ...[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPostPage(
                                postId: item['id'],
                                currentDescription: item['description'] ??
                                    '',
                                currentImageUrl: item['imageUrl'] ??
                                    '',
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
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

  void _deletePost(String postId) async {
    final postRef = FirebaseDatabase.instance.ref('posts/$postId');
    await postRef.remove();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post deletado com sucesso!')),
    );
  }
}

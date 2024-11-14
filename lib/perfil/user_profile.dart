import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPage extends StatelessWidget {
  final String userId;

  const UserPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Perfil do Usuário'),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: UserProfileBody(userId: userId),
    );
  }
}

class UserProfileBody extends StatefulWidget {
  final String userId;

  const UserProfileBody({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileBodyState createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody> {
  String username = '';
  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _fetchUserPosts();
  }

  Future<String?> _fetchProfilePictureUrl() async {
    final snapshot = await FirebaseDatabase.instance
        .ref("users/${widget.userId}/profilePictureUrl")
        .get();
    if (snapshot.exists) {
      return snapshot.value as String;
    }
    return null;
  }

  Future<void> _fetchUsername() async {
    final snapshot =
        await FirebaseDatabase.instance.ref("users/${widget.userId}/username").get();
    if (snapshot.exists) {
      setState(() {
        username = snapshot.value as String;
      });
    }
  }

  Future<void> _fetchUserPosts() async {
    final snapshot = await FirebaseDatabase.instance
        .ref("posts")
        .orderByChild("userId")
        .equalTo(widget.userId)
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
        ? const Center(child: Text("Nenhum post encontrado."))
        : GridView.builder(
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
          if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty)
            Image.network(
              post['imageUrl'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 8),
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

  Widget _buildStartConversationButton() {
    return ElevatedButton(
      onPressed: () {
        // Lógica para iniciar uma conversa com o usuário
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      child: const Text('Iniciar Conversa'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildStartConversationButton(),
          const SizedBox(height: 20),
          _buildPostsGrid(),
        ],
      ),
    );
  }
}

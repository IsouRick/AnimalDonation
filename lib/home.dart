import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importação do Google Fonts
import 'perfil/perfil.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> feedItems = [
    {
      'imageAsset': 'assets/images/fotoperfilmulher.jpg',
      'username': 'usuario1',
      'likes': 0,
    },
    {
      'imageAsset': 'assets/images/fotoperfilmulher.jpg',
      'username': 'usuario2',
      'likes': 0,
    },
  ];

  final TextEditingController _customReportController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _showComponentsWithDelay();
  }

  void _showComponentsWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _customReportController.dispose();
    super.dispose();
  }

  void _likePost(int index) {
    setState(() {
      feedItems[index]['likes'] += 1;
    });
  }

  void _startChat(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(ownerName: feedItems[index]['username']!),
      ),
    );
  }

  void _showReportDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Motivo do Reporte'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text('Você tem certeza de que deseja reportar este post?'),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Conteúdo Inadequado'),
                onTap: () {
                  Navigator.pop(context);
                  _reportPost(index, 'Conteúdo Inadequado');
                },
              ),
              ListTile(
                title: const Text('Spam'),
                onTap: () {
                  Navigator.pop(context);
                  _reportPost(index, 'Spam');
                },
              ),
              ListTile(
                title: const Text('Outro'),
                onTap: () {
                  Navigator.pop(context);
                  _showCustomReportField(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomReportField(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informe o Motivo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Digite o motivo para reportar este post:'),
              TextField(
                controller: _customReportController,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Motivo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String customReason = _customReportController.text.trim();
                if (customReason.isNotEmpty) {
                  Navigator.pop(context);
                  _reportPost(index, customReason);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite um motivo válido.')),
                  );
                }
              },
              child: const Text('Reportar'),
            ),
          ],
        );
      },
    );
  }

  void _reportPost(int index, String reason) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Você reportou o post de "${feedItems[index]['username']}" por: $reason'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

 AppBar _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Row(
      children: [
        Text(
          'Sweet Home',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
      ],
    ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PerfilPage()),
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
              radius: 20,
            ),
          ),
        ),
      ],
    );
  }

  // Função para construir o corpo da página
  Widget _buildBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: feedItems.length,
                itemBuilder: (context, index) {
                  final item = feedItems[index];
                  return _buildFeedItem(item, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir um item do feed
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
                  item['username']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'report') {
                      _showReportDialog(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'report',
                      child: Text('Reportar'),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          Image.asset(
            item['imageAsset']!,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '${item['likes']} curtidas',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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
                  onPressed: () => _startChat(index),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String ownerName;

  ChatPage({required this.ownerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat com $ownerName")),
      body: Center(child: Text("Chat com $ownerName")),
    );
  }
}

import 'package:flutter/material.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários Bloqueados'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Aqui você verá os usuários que você bloqueou.'),
      ),
    );
  }
}

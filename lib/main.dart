import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'home.dart'; // Importando o HomePage
import 'create_post.dart'; // Importando o CreatePostPage
import 'package:firebase_database/firebase_database.dart';

final databaseRef = FirebaseDatabase.instance.refFromURL('https://sweet-1a3e7-default-rtdb.firebaseio.com');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializando o Firebase
  await runZonedGuarded(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  }, (error, stackTrace) {
    print('Erro capturado: $error');
    print(stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Donation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Definindo as rotas para navegação
      routes: {
        '/': (context) => const HomePage(), // Rota principal (HomePage)
        '/create-post': (context) => const CreatePostPage(), // Rota para criar post
      },
    );
  }
}

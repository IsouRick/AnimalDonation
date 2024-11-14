import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'home.dart';
import 'create_post.dart';
import 'login_page.dart'; // Importando a página de login
import 'package:firebase_database/firebase_database.dart';
import 'perfil/Configs/config.dart'; 
import 'perfil/Configs/animalregister.dart'; 

final databaseRef = FirebaseDatabase.instance.refFromURL('https://sweet-1a3e7-default-rtdb.firebaseio.com');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        '/login': (context) => const LoginPage(), // Rota de login
        '/configuracao': (context) => ConfigPage(), // Defina a rota aqui
        '/animalregister': (context) => AnimalRegistrationPage(),
      },
      initialRoute: '/login', // Definindo a rota inicial como LoginPage
    );
  }
}

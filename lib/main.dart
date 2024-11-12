import 'package:flutter/material.dart';
import 'home.dart';
import 'login/login_page.dart';
import 'perfil/perfil.dart';
import 'perfil/Configs/animalregister.dart';
import 'perfil/Configs/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Donation',
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/configuracao': (context) => const ConfiguracaoPage(),
        '/registeredAnimals': (context) => const RegisterAnimal(),
        '/perfil': (context) => const PerfilPage(),
      },
    );
  }
}

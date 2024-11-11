import 'package:flutter/material.dart';

import 'home.dart';
import 'login/login_page.dart';
import 'perfil/Configs/Messages.dart';
import 'perfil/Configs/Status.dart';
import 'perfil/Configs/about.dart';
import 'perfil/Configs/animalregister.dart';
import 'perfil/Configs/blocked.dart';
import 'perfil/Configs/central.dart';
import 'perfil/Configs/config.dart';
import 'perfil/Configs/help.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sweet Home',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/status': (context) => const StatusPage(),
        '/privacy_center': (context) => const PrivacyCenterPage(),
        '/configuracao': (context) => ConfiguracaoPage(),
        '/blocked': (context) => const BlockedPage(),
        '/help': (context) => const HelpPage(),
        '/about': (context) => const AboutPage(),
        '/messages': (context) => MessagesPage(),
        '/registeredAnimals': (context) => RegisterAnimal(),

      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AnimalDetailsPage extends StatefulWidget {
  final String animalId;

  const AnimalDetailsPage({Key? key, required this.animalId}) : super(key: key);

  @override
  _AnimalDetailsPageState createState() => _AnimalDetailsPageState();
}

class _AnimalDetailsPageState extends State<AnimalDetailsPage> {
  late Map<String, dynamic> animalDetails = {};

  @override
  void initState() {
    super.initState();
    _fetchAnimalDetails();
  }

  Future<void> _fetchAnimalDetails() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseDatabase.instance
          .ref("users/$userId/animals/${widget.animalId}")
          .get();

      if (snapshot.exists) {
        setState(() {
          animalDetails = Map<String, dynamic>.from(
              snapshot.value as Map<dynamic, dynamic>);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Animal'),
        backgroundColor: Colors.teal,
      ),
      body: animalDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(animalDetails['imageUrl']),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    animalDetails['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Idade: ${animalDetails['age']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Espécie: ${animalDetails['species']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Descrição: ${animalDetails['description']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}

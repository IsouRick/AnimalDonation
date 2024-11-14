import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticatorServ {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<String> createUser({
    required String nome,
    required String senha,
    required String email,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      String userId = userCredential.user!.uid;

      await _databaseRef.child('users').child(userId).set({
        'username': nome,
        'email': email,
        'profilePictureUrl': '',
      });

      return "Usuário criado com sucesso!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'A senha fornecida é fraca.';
      } else if (e.code == 'email-already-in-use') {
        return 'Este email já está em uso.';
      } else if (e.code == 'invalid-email') {
        return 'O email fornecido não é válido.';
      } else {
        return 'Erro desconhecido: ${e.message}';
      }
    } catch (e) {
      return 'Erro ao criar a conta: $e';
    }
  }
}

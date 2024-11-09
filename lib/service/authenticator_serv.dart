import 'package:firebase_auth/firebase_auth.dart';

class AuthenticatorServ {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> createUser({
    required String nome,
    required String senha,
    required String email,
  }) async {
    try {
      // Criação do usuário com o email e senha fornecidos
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // O usuário foi criado com sucesso, então podemos retornar um sucesso
      return "Usuário criado com sucesso!";
    } on FirebaseAuthException catch (e) {
      // Aqui estamos capturando os erros específicos do Firebase
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
      // Qualquer outro erro não relacionado ao Firebase
      return 'Erro ao criar a conta: $e';
    }
  }
}

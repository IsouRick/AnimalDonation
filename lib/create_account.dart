import 'package:doacao_animal/service/authenticator_serv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  // Controladores para os campos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final AuthenticatorServ _authservice = AuthenticatorServ();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFF3498DB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _controller,
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: CupertinoTextField(
                        controller: _emailController,
                        padding: const EdgeInsets.all(15),
                        placeholder: "E-mail",
                        placeholderStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 210, 103),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: CupertinoTextField(
                        controller: _passwordController,
                        padding: const EdgeInsets.all(15),
                        placeholder: "Senha",
                        placeholderStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 210, 103),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: CupertinoTextField(
                        controller: _nameController,
                        padding: const EdgeInsets.all(15),
                        placeholder: "Nome",
                        placeholderStyle: const TextStyle(color: Colors.black, fontSize: 14),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 246, 210, 103),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String name = _nameController.text;

                        // Chama o método de criação de usuário
                        String result = await _authservice.createUser(
                          nome: name,
                          senha: password,
                          email: email,
                        );

                        // Exibe a mensagem de erro ou sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Criar Conta",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

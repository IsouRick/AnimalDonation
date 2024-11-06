import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Login - trocar por imagem"),
        // title: Image(
        //   image: NetworkImage("link"),
        //   width: 140,
        // ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFFFFC107),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Login",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const CupertinoTextField(
              padding: EdgeInsets.all(15),
              placeholder: "Digite o seu email",
              placeholderStyle: TextStyle(color: Colors.white70, fontSize: 14),
              style: TextStyle(color: Colors.white70, fontSize: 14),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            const SizedBox(height: 5),
            const CupertinoTextField(
              padding: EdgeInsets.all(15),
              placeholder: "Digite a sua senha",
              obscureText: true,
              placeholderStyle: TextStyle(color: Colors.white70, fontSize: 14),
              style: TextStyle(color: Colors.white70, fontSize: 14),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () { },
                child: const Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.all(17),
                color: Colors.deepOrange,
                child: const Text(
                  "Acessar",
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                child: const Text(
                  "Crie sua Conta",
                  style: TextStyle(
                    color: Colors.white,
              
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cfp_app/pages/componentes/campoForm.dart';
import 'package:cfp_app/pages/componentes/hiperlink.dart';
import 'package:cfp_app/modelos/User.dart' as LocalUser;
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmarSenha = TextEditingController();

  Future<void> cadastrar() async {
    if (_formKey.currentState!.validate()) {
      // Form validation succeeded, create a User object
      final user = LocalUser.User(
        username: _username.text,
        email: _email.text,
        password: _senha.text,
      );

      // Call a registration API or database method
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );
        String uid = userCredential.user!.uid;
        db.collection("usuarios").doc(uid).set({
          'id': uid,
          'username': _username.text,
          'email': _email.text,
        });
        Navigator.pushReplacementNamed(context, '/');
        User? usuario = userCredential.user!;
        await usuario.updateDisplayName(_username.text);
      } catch (error) {
        // Handle registration failure
        print("User registration failed: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 52,
              ),
              const Text(
                'Customer Flight Predictor',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 102,
                height: 102,
                child: Image.asset("assets/images/logo.png"),
              ),
              const SizedBox(height: 30),
              CampoForm(
                controller: _username,
                obscureText: false,
                icon: const Icon(Icons.person, color: Colors.white),
                hintText: 'Digite seu nome de usuário',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome de usuário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CampoForm(
                controller: _email,
                obscureText: false,
                icon: const Icon(Icons.email, color: Colors.white),
                hintText: 'Digite seu email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CampoForm(
                controller: _senha,
                obscureText: true,
                icon: const Icon(Icons.lock, color: Colors.white),
                hintText: 'Digite sua senha',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CampoForm(
                controller: _confirmarSenha,
                obscureText: true,
                icon: const Icon(Icons.lock, color: Colors.white),
                hintText: 'Confirme sua senha',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Botao(fn: cadastrar, texto: "Cadastrar"),
              const SizedBox(height: 16),
              const Hiperlink(
                texto: '',
                caminho: '/',
                entrarCadastrar: 'Já possuo conta',
              ),
            ],
          )),
    ));
  }
}

import 'dart:js_interop';
import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import 'componentes/botao.dart';
import './componentes/hiperlink.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 90.0,
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

        // Logo
        SizedBox(
          width: 256.0,
          height: 175.0,
          child: Image.asset("assets/images/logo.png"),
        ),
        const SizedBox(
          height: 20.0,
        ),

        // Campo de email
        CampoForm(
          controller: _email,
          obscureText: false,
          hintText: 'Email',
          icon: const Icon(Icons.email, color: Colors.white),
          validator: (_) => null,
        ),

        const SizedBox(
          height: 32.0,
        ),

        // Campo de senha
        CampoForm(
          controller: _senha,
          obscureText: true,
          hintText: 'Senha',
          icon: const Icon(Icons.lock, color: Colors.white),
          validator: (_) => null,
        ),

        const SizedBox(
          height: 32.0,
        ),

        // Botão de entrar
        Botao(
          fn: validarCampos,
          texto: 'Entrar',
        ),

        const SizedBox(
          height: 16.0,
        ),

        // Hiperlink
        const Hiperlink(
          texto: 'Primeiro acesso?',
          caminho: '/cadastro',
          entrarCadastrar: 'Cadastre-se',
        ),
      ],
    )));
  }

  validarCampos() {
    String email = _email.text;
    String senha = _senha.text;

    if (email.isNull || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, insira um email.',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return null;
    } else if (senha.isNull || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, digite a senha.',
            textAlign: TextAlign.center,
          ),
        ),
      );
      return null;
    }

    logar();
  }

  logar() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email.text,
        password: _senha.text,
      );
      Navigator.pushReplacementNamed(context, '/menu');
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Digite um email válido.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email não cadastrado.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Senha incorreta. Tente novamente.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }
}

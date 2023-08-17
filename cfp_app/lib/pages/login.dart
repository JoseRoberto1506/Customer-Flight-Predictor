import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import 'componentes/botao.dart';
import './componentes/hiperlink.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _email = TextEditingController();
  final _senha = TextEditingController();

  @override
  Widget build(BuildContext context){
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
            const Botao(
               fn: logar,
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
            
          ],)
      )
    );
  }
}

logar() async {}
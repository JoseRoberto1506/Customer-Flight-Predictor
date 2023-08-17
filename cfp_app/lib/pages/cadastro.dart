import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:flutter/material.dart';
import 'package:cfp_app/pages/componentes/campoForm.dart';
import 'package:cfp_app/pages/componentes/hiperlink.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmarSenha = TextEditingController();

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
              const Botao(fn: cadastrar, texto: "Cadastrar"),
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

cadastrar() {
  print("Teste botão");
}

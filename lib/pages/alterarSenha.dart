import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import './componentes/botao.dart';

class TelaAlterarSenha extends StatefulWidget {
  const TelaAlterarSenha({super.key});

  @override
  State<TelaAlterarSenha> createState() => _TelaAlterarSenhaState();
}

class _TelaAlterarSenhaState extends State<TelaAlterarSenha> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _novaSenha = TextEditingController();
  final _confirmarNovaSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 52),
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
              const Icon(
                Icons.person,
                color: Colors.white,
                size: 70,
              ),
              const SizedBox(height: 70),
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
                controller: _novaSenha,
                obscureText: true,
                icon: const Icon(Icons.lock, color: Colors.white),
                hintText: 'Digite a nova senha',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a nova senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CampoForm(
                controller: _confirmarNovaSenha,
                obscureText: true,
                icon: const Icon(Icons.lock, color: Colors.white),
                hintText: 'Confirme sua nova senha',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua nova senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 70),
              Botao(
                fn: () {
                  if (_formKey.currentState!.validate()) {
                    if (_novaSenha.text == _confirmarNovaSenha.text) {
                      alterarSenha(_novaSenha.text);
                      navegar(context, '/menu');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'A nova senha não corresponde à confirmação.')),
                      );
                    }
                  }
                },
                texto: 'Alterar Senha',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/menu'),
                texto: 'Voltar',
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  alterarSenha(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        print('senha alterada');
      } catch (e) {
        print('error$e');
      }
    }
  }
}
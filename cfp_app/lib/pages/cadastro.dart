import 'package:flutter/material.dart';

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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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

              const SizedBox(height: 40),
              SizedBox(
                width: 102,
                height: 102,
                child: Image.asset("assets/logo.png"),
              ),

              const SizedBox(height: 40),
              TextFormField(
                controller: _username,
                obscureText: false,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF242425),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(Icons.person),
                  ),
                  hintText: 'Digite seu nome de usuário',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome de usuário';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _email,
                obscureText: false,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF242425),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(Icons.email),
                  ),
                  hintText: 'Digite seu email',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _senha,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF242425),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(Icons.lock),
                  ),
                  hintText: 'Digite sua senha',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmarSenha,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF242425),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(Icons.lock),
                  ),
                  hintText: 'Confirme sua senha',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  fixedSize: const Size(160, 40)
                ),
                onPressed: () {},
                child: const Text(
                  'Cadastrar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}
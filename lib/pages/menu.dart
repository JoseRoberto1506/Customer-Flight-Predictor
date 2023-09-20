import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'componentes/botao.dart';

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenu();
}

class _TelaMenu extends State<TelaMenu> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? nome = '';

  @override
  Widget build(BuildContext context) {
    nome = user!.displayName;
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                color: Colors.white,
                size: 70,
              ),
              Text(
                '$nome',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 70),
              Botao(
                fn: () => navegar(context, '/lista_clientes'),
                texto: 'Lista de Clientes',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/lista_promocoes'),
                texto: 'Lista de Promoções',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/configuracoes'),
                texto: 'Configurações',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/'),
                texto: 'Sair',
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}

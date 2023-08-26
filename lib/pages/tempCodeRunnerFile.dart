import 'package:cfp_app/pages/cadastrar_cliente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'componentes/botao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenu();
}

class _TelaMenu extends State<TelaMenu> {
  CollectionReference usercollection =
      FirebaseFirestore.instance.collection('usuarios');

  final User? user = FirebaseAuth.instance.currentUser;
  final cadastrarClienteRoute = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const TelaCadastrarCliente(),
  );
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
                fn: () => navegar(context, '/cadastrarcliente'),
                texto: 'Cadastrar Clientes',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/cadastrarcliente'),
                texto: 'Lista de Clientes',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/cadastrarcliente'),
                texto: 'Configurações',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/cadastrarcliente'),
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

import 'package:cfp_app/pages/cadastrar_cliente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'componentes/botao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoes();
}

class _TelaConfiguracoes extends State<TelaConfiguracoes> {
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
                fn: () => navegar(context, '/nome'),
                texto: 'Alterar usuário',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/senha'),
                texto: 'Alterar senha',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/sobre'),
                texto: 'Sobre o app',
              ),
              const SizedBox(height: 30),
              Botao(
                fn: () => navegar(context, '/menu'),
                texto: 'Voltar para Menu',
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

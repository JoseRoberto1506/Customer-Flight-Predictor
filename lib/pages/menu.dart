import 'package:cfp_app/pages/cadastrar_cliente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'componentes/botao.dart';

class TelaMenu extends StatefulWidget {
  const TelaMenu({super.key});

  @override
  State<TelaMenu> createState() => _TelaMenu();
}

class _TelaMenu extends State<TelaMenu> {
  final User? user = FirebaseAuth.instance.currentUser; // Substitua pelo nome real do usuário
  final cadastrarClienteRoute = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TelaCadastrarCliente(),
    );

  @override
  Widget build(BuildContext context) {
    String username = user?.displayName ?? 'Nome de usuário';
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              username,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Botao(
              fn: ()=> navegar(context,'/cadastrarcliente'),
              texto: 'Cadastrar Clientes',
            ),
            SizedBox(height: 20),
            Botao(
              fn: ()=> navegar(context,'/cadastrarcliente'),
              texto: 'Lista de Clientes',
            ),
            SizedBox(height: 20),
            Botao(
              fn: ()=> navegar(context,'/cadastrarcliente'),
              texto: 'PLanos de Ação',
            ),
            SizedBox(height: 20),
            Botao(
              fn: ()=> navegar(context,'/cadastrarcliente'),
              texto: 'Configuração',
            ),

            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  void navegar(BuildContext context, String routeName) {
  Navigator.pushReplacementNamed(context, routeName);
}
}
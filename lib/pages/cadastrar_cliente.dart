// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cfp_app/pages/componentes/dialogConfirm.dart';
import 'package:flutter/material.dart';
import './componentes/campoForm.dart';
import './componentes/botao.dart';
import './componentes/dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaCadastrarCliente extends StatefulWidget {
  const TelaCadastrarCliente({super.key});

  @override
  State<TelaCadastrarCliente> createState() => _TelaCadastrarCliente();
}

class _TelaCadastrarCliente extends State<TelaCadastrarCliente> {
  final db = FirebaseFirestore.instance;
  final _nomeCliente = TextEditingController();
  final _cpfCliente = TextEditingController();
  final _nascimentoCliente = TextEditingController();
  final _sexoCliente = TextEditingController();
  final _pchurnCliente = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  List<String> churn = ['Sim', 'Não'];

  // final _nomeCliente = GlobalKey<FormState>();

  Future<void> cadastrarcliente() async {
    final cliente = <String, dynamic>{
      "nome": _nomeCliente.text,
      "cpf": _cpfCliente.text,
      "data_nascimento": _nascimentoCliente.text,
      "sexo": _sexoCliente.text,
      "probabilidade_churn": _pchurnCliente.text,
    };
    String? uid = user?.uid;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('usuarios').doc(uid);
    CollectionReference listaClientesRef =
        userDocRef.collection('listaclientes');

    listaClientesRef.add(cliente).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));

    bool? confirmado = await ConfirmationDialog.show(
      context,
      'Cadastro Confirmado',
      'Deseja cadastrar um novo usuario?',
    );
    if (confirmado == true) {
      _nomeCliente.clear();
      _cpfCliente.clear();
      _nascimentoCliente.clear();
      _sexoCliente.clear();
      _pchurnCliente.clear();
    } else {
      navegar(context, '/listaClientes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 52,
            ),
            const Text(
              'Cadastrar cliente',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 52,
            ),
            CampoForm(
              controller: _nomeCliente,
              obscureText: false,
              hintText: 'Nome completo',
              icon: const Icon(Icons.person, color: Colors.white),
              validator: (_) => null,
            ),
            const SizedBox(
              height: 20,
            ),
            CampoForm(
              controller: _cpfCliente,
              obscureText: false,
              hintText: 'CPF',
              icon: const Icon(Icons.person, color: Colors.white),
              validator: (_) => null,
            ),
            const SizedBox(
              height: 20,
            ),
            CampoForm(
              controller: _nascimentoCliente,
              obscureText: false,
              hintText: 'Data de nascimento',
              icon: const Icon(Icons.person, color: Colors.white),
              validator: (_) => null,
            ),
            const SizedBox(
              height: 20,
            ),
            Dropdown(
              controller: _sexoCliente, // Use o controlador _pchurnCliente
              dropOpcoes: ['Masculino', 'Feminino'],
              hint: 'Sexo',
              icon: Icon(Icons.directions_run_outlined, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Dropdown(
              controller: _pchurnCliente, // Use o controlador _pchurnCliente
              dropOpcoes: ['Grande chance de sair', 'Pouca chance de sair'],
              hint: 'Probabilidade de Churn',
              icon: Icon(Icons.directions_run_outlined, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Botao(fn: cadastrarcliente, texto: "Cadastrar"),
            const SizedBox(
              height: 20,
            ),
            Botao(fn: () => navegar(context, '/menu'), texto: "Voltar"),
          ],
        ),
      ),
    )));
  }

  void navegar(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}

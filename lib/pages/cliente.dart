// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaCliente extends StatefulWidget {
  const TelaCliente({Key? key, required this.cliente}) : super(key: key);
  final Map<String, dynamic> cliente;

  @override
  State<TelaCliente> createState() => _TelaClienteState();
}

class _TelaClienteState extends State<TelaCliente> {
  late Future<List<Map<String, dynamic>>> dadosClienteFuture;

  @override
  void initState() {
    super.initState();
    // Fetch client data when the widget is initialized
    dadosClienteFuture = getDadosCliente();
  }

  Future<List<Map<String, dynamic>>> getDadosCliente() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      DocumentReference dadosClienteref = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaclientes')
          .doc(widget.cliente['documentId']);

      DocumentSnapshot dadosClienteSnapshot = await dadosClienteref.get();

      List<Map<String, dynamic>> dados_do_cliente = [];
      Map<String, dynamic> data =
          dadosClienteSnapshot.data() as Map<String, dynamic>;
      dados_do_cliente.add(data);

      return dados_do_cliente;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/listaClientes');
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Dados do cliente'),
      ),
      body: FutureBuilder(
        future: dadosClienteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            List<Map<String, dynamic>> dados_cliente =
                snapshot.data as List<Map<String, dynamic>>;
            print(dados_cliente);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  Text(
                    dados_cliente[0]['nome'],
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(
                    height: 52,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 350,
                      height: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 71, 70, 70),
                        borderRadius: BorderRadius.circular(25),
                        shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'CPF: ${dados_cliente[0]['cpf']}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Data de nascimento: ${dados_cliente[0]['data_nascimento']}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Sexo: ${dados_cliente[0]['sexo']}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              'Churn: ${dados_cliente[0]['probabilidade_churn']}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Botao(fn: () {}, texto: 'Cadastrar Plano'),
                            // Add more Text widgets to display additional data
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

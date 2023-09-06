// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'componentes/dialogConfirm.dart';
import 'package:cfp_app/pages/componentes/addPlanDialog.dart';
import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/providers/clientes_provider.dart';

class TelaCliente extends StatefulWidget {
  final Cliente cliente;
  final String? clienteId;

  const TelaCliente({
    Key? key,
    required this.cliente,
    required this.clienteId,
  }) : super(key: key);

  @override
  State<TelaCliente> createState() => _TelaClienteState();
}

class _TelaClienteState extends State<TelaCliente> {
  late Future<Cliente> dadosClienteFuture;
  late Future<List<Map<String, dynamic>>> planosClienteFuture;
  final ClientesProvider clienteController = ClientesProvider();

  @override
  void initState() {
    super.initState();
    // Fetch client data when the widget is initialized
    dadosClienteFuture = clienteController.getDadosCliente(widget.clienteId);
    planosClienteFuture = getPlanosCliente();
  }

  deletarPlano(String documentId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    if (uid != null) {
      try {
        CollectionReference listaPlanosRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('listaPlanos');
        await listaPlanosRef.doc(documentId).delete();
        onPlanAdded();
      } catch (e) {
        print('error: $e');
      }
    }
  }

  void onPlanAdded() {
    setState(() {
      planosClienteFuture = getPlanosCliente();
    });
  }

  Future<List<Map<String, dynamic>>> getPlanosCliente() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaPlanosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaPlanos');

      QuerySnapshot planosSnapshot = await listaPlanosRef
          .where('clienteId', isEqualTo: widget.cliente['documentId'])
          .get();

      List<Map<String, dynamic>> planos = [];
      planosSnapshot.docs.forEach((doc) {
        Map<String, dynamic> planoData = doc.data() as Map<String, dynamic>;
        planoData['id'] = doc.id; // Add the plan's ID to the data
        planos.add(planoData);
      });

      return planos;
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
                Navigator.pushReplacementNamed(context, '/lista_clientes');
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: const Text('Dados do cliente'),
        backgroundColor: Color(0xFF313133),
      ),
      body: FutureBuilder(
        future: Future.wait([dadosClienteFuture, planosClienteFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            Cliente dadosCliente = snapshot.data as Cliente;
            List<Map<String, dynamic>> planosCliente =
                snapshot.data?[1] as List<Map<String, dynamic>>;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 52,
                  ),
                  Text(
                    dadosCliente.getNome(),
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
                              'CPF: ${dadosCliente.getCPF()}',
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
                              'Data de nascimento: ${dadosCliente.getDataNasc()}',
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
                              'Sexo: ${dadosCliente.getSexo()}',
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
                              'Churn: ${dadosCliente.getChanceChurn()}',
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
                            Botao(
                                fn: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddPlanDialog(
                                        cliente: widget.cliente,
                                        clienteId: widget.cliente['documentId'],
                                        onPlanAdded: onPlanAdded,
                                      );
                                    },
                                  );
                                },
                                texto: 'Cadastrar Plano'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Display plans
                  if (planosCliente.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          'Planos:',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: planosCliente.map((plano) {
                              return ListTile(
                                  title: Text(
                                    plano['nome'],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: plano['tarefas']
                                        .map<Widget>((tarefa) => Text(
                                              tarefa,
                                              style: TextStyle(
                                                  color:
                                                      Colors.lightBlueAccent),
                                            ))
                                        .toList(),
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushReplacementNamed(
                                                  context, '/alterarPlano',
                                                  arguments: plano);
                                            },
                                            icon: Icon(Icons.edit),
                                            color: Colors.white),
                                        IconButton(
                                          onPressed: () async {
                                            bool? deleteConfirmed =
                                                await ConfirmationDialog.show(
                                              context,
                                              'Confirmação',
                                              'Tem certeza que deseja excluir este plano?',
                                            );

                                            if (deleteConfirmed == true) {
                                              await deletarPlano(plano['id']);
                                              planosClienteFuture =
                                                  getPlanosCliente();
                                            }
                                          },
                                          icon: const Icon(Icons.delete),
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ));
                            }).toList(),
                          ),
                        ),
                      ],
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

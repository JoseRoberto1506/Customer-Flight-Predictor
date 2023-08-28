// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'componentes/dialogConfirm.dart';
import 'package:cfp_app/pages/Provider/ClientesProvider.dart';
import 'package:cfp_app/pages/componentes/addPlanDialog.dart';
import 'package:cfp_app/pages/componentes/botao.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaCliente extends StatefulWidget {
  const TelaCliente({
    Key? key,
    required this.cliente,
    required this.clienteId,
  }) : super(key: key);
  final Map<String, dynamic> cliente;
  final String? clienteId;

  @override
  State<TelaCliente> createState() => _TelaClienteState();
}

class _TelaClienteState extends State<TelaCliente> {
  late Future<List<Map<String, dynamic>>> dadosClienteFuture;
  late Future<List<Map<String, dynamic>>> planosClienteFuture;

  @override
  void initState() {
    super.initState();
    // Fetch client data when the widget is initialized
    dadosClienteFuture = getDadosCliente();
    planosClienteFuture = getPlanosCliente();
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
      data['documentId'] = dadosClienteSnapshot.id;
      dados_do_cliente.add(data);

      return dados_do_cliente;
    } else {
      return [];
    }
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
                Navigator.pushReplacementNamed(context, '/listaClientes');
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
            List<Map<String, dynamic>> dados_cliente =
                snapshot.data?[0] as List<Map<String, dynamic>>;
            List<Map<String, dynamic>> planosCliente =
                snapshot.data?[1] as List<Map<String, dynamic>>;

            final data = snapshot.data;
            if (data != null && data.length == 2) {
              dados_cliente = (data[0] as List<Map<String, dynamic>>?) ?? [];
              planosCliente = (data[1] as List<Map<String, dynamic>>?) ?? [];
            }
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
                                            onPressed: () {},
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

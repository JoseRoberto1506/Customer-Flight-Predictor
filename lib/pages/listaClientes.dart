import 'package:cfp_app/pages/cadastrar_cliente.dart';
import 'package:cfp_app/pages/cliente.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'componentes/dialogConfirm.dart';

class ListaClientes extends StatefulWidget {
  const ListaClientes({Key? key}) : super(key: key);

  @override
  _ListaClientesState createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getClientList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While data is being fetched
        } else if (snapshot.hasError) {
          return const Text('Error loading data'); // If there's an error
        } else {
          List<Map<String, dynamic>> clientes =
              snapshot.data as List<Map<String, dynamic>>;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de clientes'),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cadastrarcliente');
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, i) {
                final cliente = clientes[i];

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCliente(cliente: cliente)),
                    );
                  },
                  title: Text(cliente['nome']),
                  subtitle: Text(cliente['cpf']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool? deleteConfirmed =
                                await ConfirmationDialog.show(
                              context,
                              'Confirmação',
                              'Tem certeza que deseja excluir este cliente?',
                            );

                            if (deleteConfirmed == true) {
                              await deletarCliente(cliente['documentId']);
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                  // Add more widgets here to display other client details
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> getClientList() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaClientesRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaclientes');

      QuerySnapshot listaClientesSnapshot = await listaClientesRef.get();

      List<Map<String, dynamic>> clientes = [];
      listaClientesSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        clientes.add(data);
      });

      return clientes;
    } else {
      return [];
    }
  }

  Future<void> deletarCliente(String documentId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaClientesRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaclientes');
      await listaClientesRef.doc(documentId).delete();
      print('cliente deletado');
    }
  }

  Future<void> updateCliente(String documentId) async {}
}

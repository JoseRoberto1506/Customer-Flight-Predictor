import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListaClientes extends StatelessWidget {
  const ListaClientes({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getClientList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // While data is being fetched
        } else if (snapshot.hasError) {
          return Text('Error loading data'); // If there's an error
        } else {
          List<Map<String, dynamic>> clientes =
              snapshot.data as List<Map<String, dynamic>>;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Lista de clientes'),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/cadastrarcliente');
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
                            onPressed: () {}, icon: const Icon(Icons.delete))
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
        clientes.add(data);
      });

      return clientes;
    } else {
      return [];
    }
  }
}

import 'package:cfp_app/pages/lista_clientes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _clientes =
      []; // Armazenar a lista de clientes aqui

  Future<void> fetchClients() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaClientesRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaclientes');

      QuerySnapshot listaClientesSnapshot = await listaClientesRef.get();

      _clientes.clear(); // Limpar a lista antes de preenchê-la novamente

      listaClientesSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        _clientes.add(data);
      });

      notifyListeners(); // Notificar os listeners sobre a alteração na lista
    }
  }

  int get count {
    return _clientes.length; // Usar a lista armazenada no count
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

      await fetchClients(); // After deleting, refresh the client list
    }
  }
}

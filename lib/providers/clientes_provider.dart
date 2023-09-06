import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/cliente_model.dart';

class ClientesProvider {
  final List<Cliente> _clientes = [];

  int getQuantidadeClientes() => _clientes.length;

  Future<List<Cliente>> fetchClients() async {
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
        data['idCliente'] = doc.id;
        Cliente cliente = Cliente.fromJson(data);
        _clientes.add(cliente);
      });

      return _clientes;
    } else {
      return [];
    }
  }

  Future<void> deletarCliente(String? idCliente) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaClientesRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaclientes');
      await listaClientesRef.doc(idCliente).delete();
      await fetchClients(); // After deleting, refresh the client list
    }
  }

  Future<Cliente> getDadosCliente(idCliente) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      DocumentReference dadosClienteRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaclientes')
          .doc(idCliente);

      DocumentSnapshot dadosClienteSnapshot = await dadosClienteRef.get();
      Map<String, dynamic> data =
          dadosClienteSnapshot.data() as Map<String, dynamic>;
      Cliente cliente = Cliente.fromJson(data);

      return cliente;
    } else {
      throw Exception('Usuário não autenticado');
    }
  }
}

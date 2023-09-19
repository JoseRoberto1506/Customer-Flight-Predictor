import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/pedido_model.dart';

class PedidosProvider {
  final List<Pedido> _pedidos = [];

  int getQuantidadePedidos() => _pedidos.length;

  Future<List<Pedido>> fetchPedidos() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaPedidosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listapedidos');

      QuerySnapshot listaPedidosSnapshot = await listaPedidosRef.get();
      _pedidos.clear(); // Limpar a lista antes de preenchê-la novamente

      listaPedidosSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['idPedido'] = doc.id;
        Pedido pedido = Pedido.fromJson(data);
        _pedidos.add(pedido);
      });

      return _pedidos;
    } else {
      return [];
    }
  }

  Future<void> deletarPedido(String? idPedido) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaPedidosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listapedidos');
      await listaPedidosRef.doc(idPedido).delete();
      await fetchPedidos(); // After deleting, refresh the client list
    }
  }

  Future<Pedido> getDadosPedido(idPedido) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      DocumentReference dadosPedidoRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listapedidos')
          .doc(idPedido);

      DocumentSnapshot dadosPedidoSnapshot = await dadosPedidoRef.get();
      Map<String, dynamic> data =
          dadosPedidoSnapshot.data() as Map<String, dynamic>;
      Pedido pedido = Pedido.fromJson(data);

      return pedido;
    } else {
      throw Exception('Usuário não autenticado');
    }
  }
}

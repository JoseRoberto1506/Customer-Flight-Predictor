import 'package:cfp_app/models/promocao_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PromocoesProvider {
  final List<Promocao> _promocoes = [];

  int getQuantidadePromocoes() => _promocoes.length;

  Future<List<Promocao>> fetchPromocoes() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaPromocoesRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listapromocoes');

      QuerySnapshot listaPromocoesSnapshot = await listaPromocoesRef.get();
      _promocoes.clear();

      listaPromocoesSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        Promocao promocao = Promocao.fromJson(data);
        _promocoes.add(promocao);
      });

      return _promocoes;
    } else {
      return [];
    }
  }

  Future<void> deletarPromocao(String? id) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaPromocoesRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listapromocoes');
      await listaPromocoesRef.doc(id).delete();
      await fetchPromocoes();
    }
  }

  Future<Promocao> getDadosPromocao(id) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      DocumentReference dadosPromocaoRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listapromocoes')
          .doc(id);

      DocumentSnapshot dadosPromocaoSnapshot = await dadosPromocaoRef.get();
      Map<String, dynamic> data =
          dadosPromocaoSnapshot.data() as Map<String, dynamic>;
      Promocao promocao = Promocao.fromJson(data);

      return promocao;
    } else {
      throw Exception('Promoção não autenticado');
    }
  }
}

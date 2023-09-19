import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/equipamentos_model.dart';

class EquipamentosProvider {
  final List<Equipamento> _equipamentos = [];

  int getQuantidadeEquipamentos() => _equipamentos.length;

  Future<List<Equipamento>> fetchEquipamentos() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference equipamentosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('equipamentos');

      QuerySnapshot equipamentosSnapshot = await equipamentosRef.get();
      _equipamentos.clear(); // Limpar a lista antes de preenchê-la novamente

      equipamentosSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Equipamento equipamento = Equipamento.fromJson(data);
        data['idEquipamento'] = doc.id;

        _equipamentos.add(equipamento);
      });

      return _equipamentos;
    } else {
      return [];
    }
  }

  Future<void> deletarEquipamento(String? idEquipamento) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference equipamentosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('equipamentos');
      await equipamentosRef.doc(idEquipamento).delete();
      await fetchEquipamentos(); // Após a exclusão, atualize a lista de equipamentos
    }
  }

  Future<Equipamento> getDadosEquipamento(idEquipamento) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      DocumentReference dadosEquipamentoRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('equipamentos')
          .doc(idEquipamento);

      DocumentSnapshot dadosEquipamentoSnapshot = await dadosEquipamentoRef.get();
      Map<String, dynamic> data = dadosEquipamentoSnapshot.data() as Map<String, dynamic>;
      Equipamento equipamento = Equipamento.fromJson(data);

      return equipamento;
    } else {
      throw Exception('Usuário não autenticado');
    }
  }
}

import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/models/tarefa_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/plano_acao_model.dart';

class PlanoAcaoRepository {
  final List<PlanoAcao> _planos = [];

  Future<List<PlanoAcao>> getPlanosCliente(String? clienteId) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaPlanosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaPlanos');

      QuerySnapshot planosSnapshot = await listaPlanosRef
          .where('clienteId', isEqualTo: clienteId)
          .get();

      _planos.clear();
      planosSnapshot.docs.forEach((doc) {
        Map<String, dynamic> planoData = doc.data() as Map<String, dynamic>;
        planoData['id'] = doc.id;
        PlanoAcao plano = PlanoAcao.fromJson(planoData);
        _planos.add(plano);
      });

      return _planos;
    } else {
      return [];
    }
  }
Future<String?> getPlanoId(String nomeDoPlano) async {
  final User? user = FirebaseAuth.instance.currentUser;
  String? uid = user?.uid;

  if (uid != null) {
    try {
      CollectionReference listaPlanosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaPlanos');

      QuerySnapshot planosSnapshot = await listaPlanosRef
          .where('nome', isEqualTo: nomeDoPlano)
          .get();

      if (planosSnapshot.docs.isNotEmpty) {
        // Retorne o ID do primeiro documento correspondente
        return planosSnapshot.docs.first.id;
      } else {
        return null; // Não encontrou um plano com o nome especificado
      }
    } catch (e) {
      print('error: $e');
      return null;
    }
  } else {
    return null;
  }
}
Future<void> deletarPlano(String nomeDoPlano) async {
  // Obtenha o ID do plano pelo nome usando a função getPlanoId
  String? idDoPlano = await getPlanoId(nomeDoPlano);

  if (idDoPlano != null) {
    final User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    if (uid != null) {
      try {
        CollectionReference listaPlanosRef = FirebaseFirestore.instance
            .collection('usuarios')
            .doc(uid)
            .collection('listaPlanos');

        // Exclua o plano com base no ID encontrado
        await listaPlanosRef.doc(idDoPlano).delete();
      } catch (e) {
        print('error: $e');
      }
    }
  } else {
    print('Plano não encontrado');
  }
}

Future<void> atualizarStatusTarefa(PlanoAcao plano, Tarefa tarefa) async {
  String? idDoPlano = await getPlanoId(plano.nome);
  if (idDoPlano != null){
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;

    if (uid != null) {
      CollectionReference listaPlanosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaPlanos');

      DocumentReference planoRef = listaPlanosRef.doc(idDoPlano); 

      // Encontre a tarefa no plano de ação
      final tarefaIndex = plano.tarefas.indexOf(tarefa);

      if (tarefaIndex >= 0) {
        plano.tarefas[tarefaIndex] = tarefa; // Atualize a tarefa no plano
        await planoRef.update({
          'tarefas': plano.tarefas.map((t) => t.toJson()).toList(),
        });
      }
    }
  }
  
}



}
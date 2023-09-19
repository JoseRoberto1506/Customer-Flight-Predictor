import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/compromisso_model.dart';

class CompromissosRepository {
  final List<Compromisso> _compromissos = [];

  int getQuantidadeCompromissos() => _compromissos.length;

  Future<List<Compromisso>> getCompromissos() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;

    if (userId != null) {
      CollectionReference listaCompromissosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('listaCompromissos');

      QuerySnapshot compromissosSnapshot = await listaCompromissosRef.get();
      _compromissos.clear();

      for (int i = 0; i < compromissosSnapshot.docs.length; i++) {
        final doc = compromissosSnapshot.docs[i];
        Map<String, dynamic> dadosCompromisso =
            doc.data() as Map<String, dynamic>;
        dadosCompromisso['idCompromisso'] = doc.id;
        Compromisso compromisso = Compromisso.fromJson(dadosCompromisso);
        _compromissos.add(compromisso);
      }

      return _compromissos;
    } else {
      throw Exception('Usuário não autenticado');
    }
  }

  Future<Compromisso> getDadosCompromisso(idCompromisso) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;

    if (userId != null) {
      DocumentReference dadosCompromissoRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('listaCompromissos')
          .doc(idCompromisso);

      DocumentSnapshot dadosCompromissoSnapshot =
          await dadosCompromissoRef.get();
      Map<String, dynamic> dados =
          dadosCompromissoSnapshot.data() as Map<String, dynamic>;
      Compromisso compromisso = Compromisso.fromJson(dados);

      return compromisso;
    } else {
      throw Exception('Usuário não autenticado');
    }
  }

  Future<void> deletarCompromisso(String? idCompromisso) async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;

    if (userId != null) {
      CollectionReference listaCompromissosRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .collection('listaCompromissos');
      await listaCompromissosRef.doc(idCompromisso).delete();
      await getCompromissos();
    } else {
      throw Exception('Usuário não autenticado');
    }
  }
}

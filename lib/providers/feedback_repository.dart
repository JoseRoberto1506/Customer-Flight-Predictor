import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfp_app/models/feedback_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackProvider {
  final List<FeedbackCliente> _feedbackCliente = [];

  int getQuantidadeFeedbacks() => _feedbackCliente.length;

  Future<List<FeedbackCliente>> fetchFeedbacks() async {
    String? uid = getFirebaseId();

    if (uid != null) {
      CollectionReference listaFeedbacksRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaFeedbacks');

      QuerySnapshot listaFeedbacksSnapshot = await listaFeedbacksRef.get();
      _feedbackCliente.clear(); // Limpar a lista antes de preenchê-la novamente

      listaFeedbacksSnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        FeedbackCliente feedbackCliente = FeedbackCliente.fromJson(data);
        _feedbackCliente.add(feedbackCliente);
      });

      return _feedbackCliente;
    } else {
      return [];
    }
  }

  String? getFirebaseId() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;
    return uid;
  }

  Future<void> deletarFeedback(FeedbackCliente feedbackCliente) async {
    final String? uid = getFirebaseId();

    if (uid != null) {
      CollectionReference listaFeedbacksRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaFeedbacks');

      final String? feedbackId =
          feedbackCliente.feedbackId; // Obtém o ID do feedback

      if (feedbackId != null) {
        await listaFeedbacksRef.doc(feedbackId).delete();
        await fetchFeedbacks(); // Após a exclusão, atualiza a lista de feedbacks do cliente
      }
    }
  }

  Future<FeedbackCliente> getDadosFeedback() async {
    final String? uid = getFirebaseId();

    if (uid != null) {
      DocumentReference dadosFeedbacksRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaFeedbacks')
          .doc('documentId');

      DocumentSnapshot dadosFeedbackSnapshot = await dadosFeedbacksRef.get();
      Map<String, dynamic> data =
          dadosFeedbackSnapshot.data() as Map<String, dynamic>;
      FeedbackCliente feedbackCliente = FeedbackCliente.fromJson(data);

      return feedbackCliente;
    } else {
      throw Exception('Não há feedbacks cadastrados para esse cliente');
    }
  }

  Future<void> cadastrarFeedback(FeedbackCliente feedbackCliente) async {
    String? uid = getFirebaseId();
    if (uid != null) {
      CollectionReference listaFeedbacksRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaFeedbacks');

      // Criar um novo documento e definir os dados dentro dele
      DocumentReference novoDocumento = listaFeedbacksRef.doc();
      String feedbackId = novoDocumento.id;
      feedbackCliente.feedbackId = feedbackId;

      await novoDocumento.set({
        'clienteCpf': feedbackCliente.clienteCpf,
        'dataFeedback': feedbackCliente.dataFeedback,
        'satisfacaoFeedback': feedbackCliente.satisfacaoFeedback,
        'comentarioFeedback': feedbackCliente.comentarioFeedback,
        'feedbackId': feedbackId,
      });

      await novoDocumento.update(feedbackCliente.toJson());
    }
  }

  Future<void> atualizarFeedback(FeedbackCliente feedbackCliente) async {
    final String? uid = getFirebaseId();
    final String? feedbackId =
        feedbackCliente.feedbackId; // Obtém o ID do feedback

    if (uid != null && feedbackId != null) {
      CollectionReference listaFeedbacksRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('listaFeedbacks');

      // Use o ID do feedback para atualizar os dados no Firestore
      await listaFeedbacksRef.doc(feedbackId).update({
        'dataFeedback': feedbackCliente.dataFeedback,
        'satisfacaoFeedback': feedbackCliente.satisfacaoFeedback,
        'comentarioFeedback': feedbackCliente.comentarioFeedback,
      });
    }
  }
}

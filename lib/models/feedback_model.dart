import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackCliente {
  String? feedbackId;
  final String clienteCpf;
  final DateTime dataFeedback;
  final String satisfacaoFeedback;
  final String comentarioFeedback;

  FeedbackCliente({
    this.feedbackId,
    required this.clienteCpf,
    required this.dataFeedback,
    required this.satisfacaoFeedback,
    required this.comentarioFeedback,
  });

  Map<String, dynamic> toJson() => {
        'feedbackId': feedbackId,
        'clienteCpf': clienteCpf,
        'dataFeedback': dataFeedback,
        'satisfacaoFeedback': satisfacaoFeedback,
        'comentarioFeedback': comentarioFeedback,
      };
  factory FeedbackCliente.fromJson(Map<String, dynamic> json) =>
      FeedbackCliente(
        feedbackId: json['feedbackId'],
        clienteCpf: json['clienteCpf'],
        dataFeedback: (json['dataFeedback'] as Timestamp).toDate(),
        satisfacaoFeedback: json['satisfacaoFeedback'],
        comentarioFeedback: json['comentarioFeedback'],
      );

  String? getId() => feedbackId;
  String getCpf() => clienteCpf;
  DateTime getData() => dataFeedback;
  String getSatisfacao() => satisfacaoFeedback;
  String getComentario() => comentarioFeedback;
  String getNotaSatisfacao() {
    final nota = satisfacaoFeedback.split(' ')[0];
    return nota;
  }
}

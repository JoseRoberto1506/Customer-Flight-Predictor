import 'package:cfp_app/models/tarefa_model.dart';

class PlanoAcao {
  String? clienteId;
  List<Tarefa> tarefas;
  String prazo;
  bool planoFinalizado;
  String nome;

  PlanoAcao({
    required this.clienteId,
    required this.tarefas,
    this.prazo = '',
    this.planoFinalizado = false,
    required this.nome,
  });
  factory PlanoAcao.fromJson(Map<String, dynamic> json) {
    final String? clienteId =
        json['cliente']?.fromJson(json['cliente'])?.idCliente;

    final tarefasList = (json['tarefas'] as List<dynamic>)
        .map((taskJson) => Tarefa.fromJson(taskJson))
        .toList();

    return PlanoAcao(
      clienteId: clienteId,
      tarefas: tarefasList,
      prazo: json['prazo'] ?? '',
      planoFinalizado: json['planoFinalizado'] ?? false,
      nome: json['nome'] ?? '', // Initialize the nome attribute
    );
  }
  Map<String, dynamic> toJson() => {
        'clienteId': clienteId,
        'tarefas': tarefas.map((tarefa) => tarefa.toJson()).toList(),
        'prazo': prazo,
        'planoFinalizado': planoFinalizado,
        'nome': nome,
      };
}

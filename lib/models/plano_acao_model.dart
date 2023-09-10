import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/models/tarefa_model.dart';

class PlanoAcao {
  Cliente cliente;
  List<Tarefa> tarefas;
  String prazo;
  bool planoFinalizado;
  String nome;

  PlanoAcao({
    required this.cliente,
    required this.tarefas,
    this.prazo = '',
    this.planoFinalizado = false,
    required this.nome,
  });
factory PlanoAcao.fromJson(Map<String, dynamic> json) {
    final cliente = Cliente.fromJson(json['cliente']);
    final tarefasList = (json['tarefas'] as List<dynamic>)
        .map((taskJson) => Tarefa.fromJson(taskJson))
        .toList();

    return PlanoAcao(
      cliente: cliente,
      tarefas: tarefasList,
      prazo: json['prazo'] ?? '',
      planoFinalizado: json['planoFinalizado'] ?? false,
      nome: json['nome'] ?? '', // Initialize the nome attribute
    );
  }
  Map<String, dynamic> toJson() => {

      'cliente': cliente.toJson(),
      'tarefas': tarefas.map((tarefa) => tarefa.toJson()).toList(),
      'prazo': prazo,
      'planoFinalizado': planoFinalizado,
      'nome': nome,
    };
}

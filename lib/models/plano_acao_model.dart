import 'package:cfp_app/models/cliente_model.dart';
import 'package:cfp_app/models/tarefa_model.dart';

class PlanoAcao {
  Cliente cliente;
  List<Tarefa> tarefas;
  String prazo;
  bool planoFinalizado;

  PlanoAcao({
    required this.cliente,
    required this.tarefas,
    this.prazo = '',
    this.planoFinalizado = false,
  });
}

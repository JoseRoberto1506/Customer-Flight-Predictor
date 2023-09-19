class Pedido {
  final String? idPedido;
  final String data;
  final String hora;
  final String descricao;
  final String? clienteId;

  Pedido({
    this.idPedido,
    required this.data,
    required this.hora,
    required this.descricao,
    required this.clienteId,

  });

  Map<String, dynamic> toJson() => {
        'idPedido': idPedido,
        'data': data,
        'hora': hora,
        'descricao': descricao,
        'clienteId': clienteId,
      };

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        idPedido: json['idPedido'],
        data: json['data'],
        hora: json['hora'],
        descricao: json['descricao'],
        clienteId: json['clienteId']
      );

  String getData() => data; //atributos já atribuídos, não são os recebidos!
  String getHora() => hora;
  String getDescricao() => descricao;
}

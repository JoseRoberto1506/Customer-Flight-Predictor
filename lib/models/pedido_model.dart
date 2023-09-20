class Pedido {
  final String? idPedido;
  final String data;
  final String hora;
  final String descricao;
  final String titulo;
  final String? clienteId;
  final String status;

  Pedido({
    this.idPedido,
    required this.data,
    required this.hora,
    required this.descricao,
    required this.clienteId,
    required this.titulo,
    required this.status,

  });

  Map<String, dynamic> toJson() => {
        'idPedido': idPedido,
        'data': data,
        'hora': hora,
        'descricao': descricao,
        'clienteId': clienteId,
        'titulo': titulo,
        'status': status,
      };

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        idPedido: json['idPedido'],
        data: json['data'],
        hora: json['hora'],
        descricao: json['descricao'],
        clienteId: json['clienteId'],
        titulo: json['titulo'],
        status: json['status'],
      );

  String getData() => data; //atributos já atribuídos, não são os recebidos!
  String getHora() => hora;
  String getDescricao() => descricao;
  String getTitulo() => titulo;
  String getStatus () => status;
  String? getIdcliente () => clienteId;
}

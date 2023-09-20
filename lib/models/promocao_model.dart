class Promocao{
  final String? id;
  final String clienteCpf;
  final String servico;
  final String valor;

  const Promocao({
    this.id,
    required this.clienteCpf,
    required this.servico,
    required this.valor,
  });
   Map<String, dynamic> toJson() => {
        'id': id,
        'clienteCpf': clienteCpf,
        'servico':servico,
        'valor': valor,
      };

  factory Promocao.fromJson(Map<String, dynamic> json) => Promocao(
        id: json['id'],
        clienteCpf: json['clienteCpf'],
        servico: json['servico'],
        valor: json['valor'],
      );

  String getCPF() => clienteCpf;
  String getServico() =>servico;
  String getValor() => valor;
}

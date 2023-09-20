class Promocao{
  final String? id;
  final String clienteCpf;
  final String servico;
  final String valor;
  final String pagamento;

  const Promocao({
    this.id,
    required this.clienteCpf,
    required this.servico,
    required this.valor,
    required this.pagamento,
  });
   Map<String, dynamic> toJson() => {
        'id': id,
        'clienteCpf': clienteCpf,
        'servico':servico,
        'valor': valor,
        'pagamento': pagamento,
      };

  factory Promocao.fromJson(Map<String, dynamic> json) => Promocao(
        id: json['id'],
        clienteCpf: json['clienteCpf'],
        servico: json['servico'],
        valor: json['valor'],
        pagamento: json['pagamento']
      );

  String getCPF() => clienteCpf;
  String getServico() =>servico;
  String getValor() => valor;
  String getPagamento() => pagamento;
}

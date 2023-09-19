class Equipamento {
  final String? idEquipamento;
  final String nomeEquipamento;
  final String descricaoEquipamento;
  final double precoEquipamento;

  Equipamento({
    this.idEquipamento,
    required this.nomeEquipamento,
    required this.descricaoEquipamento,
    required this.precoEquipamento,
  });

  Map<String, dynamic> toJson() => {
        'idEquipamento': idEquipamento,
        'nomeEquipamento': nomeEquipamento,
        'descricaoEquipamento': descricaoEquipamento,
        'precoEquipamento': precoEquipamento,
      };

  factory Equipamento.fromJson(Map<String, dynamic> json) {
    return Equipamento(
      idEquipamento: json['idEquipamento'],
      nomeEquipamento: json['nomeEquipamento'],
      descricaoEquipamento: json['descricaoEquipamento'],
      precoEquipamento: json['precoEquipamento'].toDouble(),
    );
  }
  String getNome() => nomeEquipamento;
  String getDescricao() => descricaoEquipamento;
  double getPreco() => precoEquipamento;
}
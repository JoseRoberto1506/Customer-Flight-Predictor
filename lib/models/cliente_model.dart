class Cliente {
  final String? idCliente;
  final String nomeCliente;
  final String cpfCliente;
  final String dataNascCliente;
  final String sexoCliente;
  final String chanceChurn;

  Cliente({
    this.idCliente,
    required this.nomeCliente,
    required this.cpfCliente,
    required this.dataNascCliente,
    required this.sexoCliente,
    required this.chanceChurn,
  });

  Map<String, dynamic> toJson() => {
        'idCliente': idCliente,
        'nomeCliente': nomeCliente,
        'cpfCliente': cpfCliente,
        'dataNascCliente': dataNascCliente,
        'sexoCliente': sexoCliente,
        'chanceChurn': chanceChurn,
      };

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        idCliente: json['idCliente'],
        nomeCliente: json['nomeCliente'],
        cpfCliente: json['cpfCliente'],
        dataNascCliente: json['dataNascCliente'],
        sexoCliente: json['sexoCliente'],
        chanceChurn: json['chanceChurn'],
      );

  String getNome() => nomeCliente;
  String getCPF() => cpfCliente;
  String getDataNasc() => dataNascCliente;
  String getSexo() => sexoCliente;
  String getChanceChurn() => chanceChurn;
}

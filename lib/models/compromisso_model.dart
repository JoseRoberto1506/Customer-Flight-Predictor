class Compromisso {
  final String? idCompromisso;
  final String compromisso;
  final String tema;
  final String local;
  final String data;
  final String hora;
  final String descricao;

  Compromisso(
      {this.idCompromisso,
      required this.compromisso,
      required this.tema,
      required this.local,
      required this.data,
      required this.hora,
      required this.descricao});

  Map<String, dynamic> toJson() => {
        'idCompromisso': idCompromisso,
        'compromisso': compromisso,
        'tema': tema,
        'local': local,
        'data': data,
        'hora': hora,
        'descricao': descricao,
      };

  factory Compromisso.fromJson(Map<String, dynamic> json) => Compromisso(
        idCompromisso: json['idCompromisso'],
        compromisso: json['compromisso'],
        tema: json['tema'],
        local: json['local'],
        data: json['data'],
        hora: json['hora'],
        descricao: json['descricao'],
      );

  String getNomeCompromisso() => compromisso;
  String getTemaCompromisso() => tema;
  String getLocalCompromisso() => local;
  String getDataCompromisso() => data;
  String getHoraCompromisso() => hora;
  String getDescricaoCompromisso() => descricao;
}

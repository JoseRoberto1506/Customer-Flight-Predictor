class Tarefa {
  String tituloTarefa;
  bool isComplete;

  Tarefa({
    required this.tituloTarefa,
    this.isComplete = false,
  });
Map<String, dynamic> toJson() => {
        'tituloTarefa': tituloTarefa,
        'isComplete': isComplete,
      };

  factory Tarefa.fromJson(Map<String, dynamic> json) => Tarefa(
        tituloTarefa: json['tituloTarefa'] ?? '',
        isComplete: json['isComplete'] ?? false,
      );
}
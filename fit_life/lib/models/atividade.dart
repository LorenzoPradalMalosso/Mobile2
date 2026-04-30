// models/atividade.dart
// Modelo de dados para atividades físicas — usado em todas as telas e Provider

class Atividade {
  final String id;
  final String nome;
  final int duracaoMinutos;
  final double caloriasEstimadas;
  final bool concluida;

  Atividade({
    required this.id,
    required this.nome,
    required this.duracaoMinutos,
    required this.caloriasEstimadas,
    this.concluida = false,
  });

  /// Cria uma cópia da atividade com o campo concluído modificado
  Atividade copyWith({bool? concluida}) {
    return Atividade(
      id: id,
      nome: nome,
      duracaoMinutos: duracaoMinutos,
      caloriasEstimadas: caloriasEstimadas,
      concluida: concluida ?? this.concluida,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Atividade &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
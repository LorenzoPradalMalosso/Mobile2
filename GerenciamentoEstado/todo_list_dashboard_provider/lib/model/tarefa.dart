class Tarefa {
  // Atributos
  String titulo; // Atribui o título da tarefa
  bool concluida; // Atribui o status da tarefa
  DateTime criadaEm; // Atribui a data da tarefa

  // Construtor
  // Required = obrigatório
  Tarefa({required this.titulo, this.concluida = false, DateTime? criadaEm}): criadaEm = criadaEm ?? DateTime.now();
  // Se ao criar não existir (??) um carimbo de data e hora, é criado um
}
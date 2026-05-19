// Modelagem de dados

class Nota {
  // Atributos
  final int? id; // Permitir que a variável seja nula
  // Em um primeiro momento a variável é nula
  // Somente quando cair no DB vira receber um valor para o ID
  final String titulo;
  final String conteudo;

  // Construtor
  Nota({this.id, required this.titulo, required this.conteudo});

  // Métodos de serialização de dados (toMap() fromMap())

  //to Map() => Converter um obj da Classe Nota para MAP de DB (inserir dados no DB)
  Map<String,dynamic> toMap(){
    return{
      "id":id, // Mapeando as colunas do DB com os atributos da CLasse
      "titulo":titulo,
      "conteudo":conteudo
    };
  }

  // Converter um MAP (vindo do DB) => Obj da Clase Nota
  // Para fazer o from vamos usar um factory
  factory Nota.fromMap(Map<String,dynamic> map){
    return Nota(
      id: map["id"] as int, // Se está voltando do DB então já tem um ID
      titulo: map["titulo"] as String,
      conteudo: map["conteudo"] as String
    );
  }

  // Método para imprimir dados
  @override
  String toString() {
    return "Nota{id:$id, título:$titulo, conteúdo:$conteudo}";
  }
}
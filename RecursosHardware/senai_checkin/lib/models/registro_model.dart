class Registro {
  // Atributos
  int? id;
  String dataHora;
  double latitude;
  double longitude;
  String observacao;
  String caminhoFoto; 

  // Construtor
  Registro({
    this.id,
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    required this.observacao,
    required this.caminhoFoto,
  });

  // ToMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_hora' : dataHora,
      'latitude' : latitude,
      'longitude' : longitude,
      'observacao' : observacao,
      'caminho_foto' : caminhoFoto
    };
  }

  // FromMap => factory => construtor alternativo ao construtor principal
  factory Registro.fromMap(Map<String,dynamic> map) {
    return Registro(
      id: map['id'],
      dataHora: map['data_hora'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      observacao: map['observacao'],
      caminhoFoto: map['caminho_foto'],
    );
  }

}
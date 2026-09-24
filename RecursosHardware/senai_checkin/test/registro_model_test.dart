import 'package:flutter_test/flutter_test.dart';
import 'package:senai_checkin/models/registro_model.dart';

void main() {
  test('deve incluir a cidade no mapa do registro', () {
    final registro = Registro(
      dataHora: '2026-09-24T10:00:00.000',
      latitude: -23.5505,
      longitude: -46.6333,
      observacao: 'Visita técnica',
      caminhoFoto: '/tmp/foto.jpg',
      cidade: 'São Paulo',
    );

    final map = registro.toMap();

    expect(map['cidade'], 'São Paulo');
    expect(map['latitude'], -23.5505);
  });

  test('deve ler a cidade ao converter o mapa em registro', () {
    final registro = Registro.fromMap({
      'id': 1,
      'data_hora': '2026-09-24T10:00:00.000',
      'latitude': -23.5505,
      'longitude': -46.6333,
      'observacao': 'Visita técnica',
      'caminho_foto': '/tmp/foto.jpg',
      'cidade': 'Rio de Janeiro',
    });

    expect(registro.cidade, 'Rio de Janeiro');
  });
}

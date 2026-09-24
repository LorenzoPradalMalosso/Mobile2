import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationApiService {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String apiKey = '90290436d34bb91b4d852afe49197129';

  static Future<Map<String, dynamic>> getOne(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&lang=pt_br&units=metric'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw Exception('Resposta inválida da API de localização.');
    }

    throw Exception('Falha ao consultar o nome da cidade.');
  }

  static Future<String> buscarNomeCidade(double lat, double lon) async {
    try {
      final dados = await getOne(lat, lon);

      final nomeCidade = dados['name'];
      if (nomeCidade is String && nomeCidade.trim().isNotEmpty) {
        return nomeCidade.trim();
      }

      final nomesLocais = dados['local_names'];
      if (nomesLocais is Map && nomesLocais['pt'] is String) {
        final nomeLocal = nomesLocais['pt'] as String;
        if (nomeLocal.trim().isNotEmpty) {
          return nomeLocal.trim();
        }
      }

      return 'Cidade não identificada';
    } catch (_) {
      return 'Cidade não identificada';
    }
  }
}

class ApiService extends LocationApiService {}
